import bindbc.sdl, std.random, std.stdio;
import scenetree, gameobject, component, scriptcomponent, scenemanager;
import resourcemanager;

enum TILESIZE = 32; 

abstract class Scene{
    SceneTree tree;
    SDL_Renderer* renderer;
    SceneManager sceneManager;
    static bool gameOver = false;
    static bool win = false;
    immutable int size = 200;
    int buttonX = 400 - (size / 2);
    int buttonY = 320 - (size / 2);
    this(SDL_Renderer* renderer, SceneManager sceneManager){
        this.renderer = renderer;
        this.sceneManager = sceneManager;
    }
    void setUpScene(string image, string data);

    void resetPos(){
        // Reset position logic for the scene
        // This can be overridden in derived classes
    }
}

class MainMenu : Scene{
    this(SDL_Renderer* renderer, SceneManager sceneManager, string image, string data){
        super(renderer, sceneManager);
        setUpScene(image, data);
    }

    override void setUpScene(string image, string data){

        //make our root node for scene tree
        GameObject rootNode = new GameObject();
        tree.setRoot(rootNode);

        //background object
        GameObject bg = new GameObject();
        bg.addComponent(new TransformComponent(bg, 0, 0, 1136, 640));
        bg.addComponent(new TextureComponent(bg, renderer, "./assets/Background.bmp"));
        bg.addComponent(new AnimatedTextureComponent(bg, renderer, "./assets/Background.json"));
        bg.addComponent(new StaticScript(bg, "background"));
        rootNode.addChild(bg);

        //play button object
        GameObject playButton = new GameObject();
        playButton.addComponent(new TransformComponent(playButton, buttonX, buttonY, size, size));
        playButton.addComponent(new TextureComponent(playButton, renderer, image));
        playButton.addComponent(new AnimatedTextureComponent(playButton, renderer, data));
        playButton.addComponent(new ButtonScript(playButton, sceneManager, "play_button"));
        rootNode.addChild(playButton);
    }
}

class Level1 : Scene{
    int PB_X = 0;
    int PB_Y = 0;
    int J_X = 0;
    int J_Y = 0;
    int starCount = 0;
    GameObject peanutButter;
    GameObject jelly;
    this(SDL_Renderer* renderer, SceneManager sceneManager, string image, string data){
        super(renderer, sceneManager);
        setUpScene(image, data);
    }

    override void setUpScene(string image, string data){
        //make our root node for scene tree
        GameObject rootNode = new GameObject();
        tree.setRoot(rootNode);

        //background object
        GameObject bg = new GameObject();
        bg.addComponent(new TransformComponent(bg, 0, 0, 1136, 640));
        bg.addComponent(new TextureComponent(bg, renderer, "./assets/Background.bmp"));
        bg.addComponent(new AnimatedTextureComponent(bg, renderer, "./assets/Background.json"));
        bg.addComponent(new StaticScript(bg, "background"));
        rootNode.addChild(bg);

        //set up tiles container
        GameObject tilesContainer = new GameObject();
        rootNode.addChild(tilesContainer);
        auto tm = ResourceManager.GetInstance().LoadTileMap("./assets/maps/map.json");
        PB_X = tm.pb_spawn[1] * TILESIZE;
        PB_Y = tm.pb_spawn[0] * TILESIZE;
        J_X = tm.j_spawn[1] * TILESIZE;
        J_Y = tm.j_spawn[0] * TILESIZE;
        foreach(r; 0 .. tm.height) {
            foreach(c; 0 .. tm.width) {
                auto t = tm.tiles[r][c];
                string texFile;
                if (t != "") {
                    GameObject tileObj = new GameObject();
                    tileObj.addComponent(new TransformComponent(tileObj, c * TILESIZE, r * TILESIZE, TILESIZE, TILESIZE));
                    tileObj.addComponent(new TextureComponent(tileObj,renderer, image));

                    tileObj.addComponent(new AnimatedTextureComponent(tileObj, renderer, data));
                    tileObj.addComponent(new TileScript(tileObj, t));

                    tilesContainer.addChild(tileObj);
                }
                if(t == "star") {
                    starCount++; 
                }
            }
        }

        //set up peanut butter object
        peanutButter = new GameObject();
        peanutButter.addComponent(new TransformComponent(peanutButter, PB_X, PB_Y, 32, 32));
        peanutButter.addComponent(new TextureComponent(peanutButter, renderer, image));
        peanutButter.addComponent(new AnimatedTextureComponent(peanutButter, renderer, data));
        peanutButter.addComponent(new PeanutButterScript(peanutButter));
        peanutButter.scriptType = "PeanutButterScript"; // set script type for peanut butter
        peanutButter.id = 0; // set id for peanut butter
        rootNode.addChild(peanutButter);

        //set up jelly object
        jelly = new GameObject();
        jelly.addComponent(new TransformComponent(jelly, J_X, J_Y, 32, 32));
        jelly.addComponent(new TextureComponent(jelly, renderer, image));
        jelly.addComponent(new AnimatedTextureComponent(jelly, renderer, data));
        jelly.addComponent(new JellyScript(jelly));
        jelly.scriptType = "JellyScript"; // set script type for jelly
        jelly.id = 1; // set id for jelly
        rootNode.addChild(jelly);

        //set up merged peanut butter jelly object
        GameObject mergedPeanutButterJelly = new GameObject();
        mergedPeanutButterJelly.addComponent(new TransformComponent(mergedPeanutButterJelly, J_X, J_Y, 32, 32));
        mergedPeanutButterJelly.addComponent(new TextureComponent(mergedPeanutButterJelly, renderer, image));
        mergedPeanutButterJelly.addComponent(new AnimatedTextureComponent(mergedPeanutButterJelly, renderer, data));
        mergedPeanutButterJelly.addComponent(new MergedPeanutButterJellyScript(mergedPeanutButterJelly));
        mergedPeanutButterJelly.isActive = false; // set to invisible at the start
        mergedPeanutButterJelly.scriptType = "MergedPeanutButterJellyScript"; // set script type for merged peanut butter jelly
        mergedPeanutButterJelly.id = 2;
        rootNode.addChild(mergedPeanutButterJelly);



        // collision manager
        GameObject collisionManager = new GameObject();
        collisionManager.addComponent(new CollisionManagerScript(collisionManager, peanutButter, jelly, mergedPeanutButterJelly, tilesContainer, this, starCount));
        rootNode.addChild(collisionManager);
    }

    override void resetPos(){
        auto tm = ResourceManager.GetInstance().LoadTileMap("./assets/maps/map.json");
        auto pbTransform = peanutButter.getComponent!TransformComponent();
        auto jTransform = jelly.getComponent!TransformComponent();
        pbTransform.x = PB_X;
        pbTransform.y = PB_Y;
        peanutButter.isActive = true;
        jTransform.x = J_X;
        jTransform.y = J_Y;
        jelly.isActive = true;

    }
}

class Win : Scene{
    immutable int size = 200;
    this(SDL_Renderer* renderer, SceneManager sceneManager, string image, string data){
        super(renderer, sceneManager);
        setUpScene(image, data);
    }

    override void setUpScene(string image, string data){

        //make our root node for scene tree
        GameObject rootNode = new GameObject();
        tree.setRoot(rootNode);

        //background object
        GameObject bg = new GameObject();
        bg.addComponent(new TransformComponent(bg, 0, 0, 1136, 640));
        bg.addComponent(new TextureComponent(bg, renderer, "./assets/Background.bmp"));
        bg.addComponent(new AnimatedTextureComponent(bg, renderer, "./assets/Background.json"));
        bg.addComponent(new StaticScript(bg, "background"));
        rootNode.addChild(bg);

        //win sprite
        GameObject win = new GameObject();
        win.addComponent(new TransformComponent(win, buttonX, buttonY, size, size));
        win.addComponent(new TextureComponent(win, renderer, image));
        win.addComponent(new AnimatedTextureComponent(win, renderer, data));
        win.addComponent(new StaticScript(bg, "you_win"));
        rootNode.addChild(win);
    }
}

class GameOver : Scene{
    immutable int size = 200;
    this(SDL_Renderer* renderer, SceneManager sceneManager, string image, string data){
        super(renderer, sceneManager);
        setUpScene(image, data);
    }

    override void setUpScene(string image, string data){

        //make our root node for scene tree
        GameObject rootNode = new GameObject();
        tree.setRoot(rootNode);

        //background object
        GameObject bg = new GameObject();
        bg.addComponent(new TransformComponent(bg, 0, 0, 1136, 640));
        bg.addComponent(new TextureComponent(bg, renderer, "./assets/Background.bmp"));
        bg.addComponent(new AnimatedTextureComponent(bg, renderer, "./assets/Background.json"));
        bg.addComponent(new StaticScript(bg, "background"));
        rootNode.addChild(bg);

        //gameOver sprite
        GameObject gameOver = new GameObject();
        gameOver.addComponent(new TransformComponent(gameOver, buttonX, buttonY, size, size));
        gameOver.addComponent(new TextureComponent(gameOver, renderer, image));
        gameOver.addComponent(new AnimatedTextureComponent(gameOver, renderer, data));
        gameOver.addComponent(new StaticScript(gameOver, "game_over_1"));
        rootNode.addChild(gameOver);
    }
}