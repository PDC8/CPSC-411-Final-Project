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
    this(SDL_Renderer* renderer, SceneManager sceneManager){
        this.renderer = renderer;
        this.sceneManager = sceneManager;
    }
    void setUpScene(string image, string data);
}

class MainMenu : Scene{
    immutable int size = 200;
    int buttonX = 400 - (size / 2);
    int buttonY = 320 - (size / 2);
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
        bg.addComponent(new BgScript(bg));
        rootNode.addChild(bg);

        //play button object
        GameObject playButton = new GameObject();
        playButton.addComponent(new TransformComponent(playButton, buttonX, buttonY, size, size));
        playButton.addComponent(new TextureComponent(playButton, renderer, image));
        playButton.addComponent(new AnimatedTextureComponent(playButton, renderer, data));
        playButton.addComponent(new ButtonScript(playButton, sceneManager));
        rootNode.addChild(playButton);
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
        bg.addComponent(new BgScript(bg));
        rootNode.addChild(bg);
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
        bg.addComponent(new BgScript(bg));
        rootNode.addChild(bg);
    }
}


class Level1 : Scene{
    int PB_X = 50;
    int PB_Y = 500;
    int J_X = 100;
    int J_Y = 500;
    int starCount = 0;
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
        bg.addComponent(new BgScript(bg));
        rootNode.addChild(bg);

        //set up tiles container
        GameObject tilesContainer = new GameObject();
        rootNode.addChild(tilesContainer);
        auto tm = ResourceManager.GetInstance().LoadTileMap("./assets/maps/larger_map.json");
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
        GameObject peanutButter = new GameObject();
        peanutButter.addComponent(new TransformComponent(peanutButter, PB_X, PB_Y, 32, 32));
        peanutButter.addComponent(new TextureComponent(peanutButter, renderer, image));
        peanutButter.addComponent(new AnimatedTextureComponent(peanutButter, renderer, data));
        peanutButter.addComponent(new PeanutButterScript(peanutButter));
        peanutButter.scriptType = "PeanutButterScript"; // set script type for peanut butter
        peanutButter.id = 0; // set id for peanut butter
        rootNode.addChild(peanutButter);

        //set up jelly object
        GameObject jelly = new GameObject();
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
        mergedPeanutButterJelly.isActive = false; // set to invisible at the start!
        mergedPeanutButterJelly.scriptType = "MergedPeanutButterJellyScript"; // set script type for merged peanut butter jelly
        mergedPeanutButterJelly.id = 2;
        rootNode.addChild(mergedPeanutButterJelly);


        // // uncomment to enable feature where peanut butter and jelly can "merge" by pressing space key
        // // merge manager
        // GameObject mergeManager = new GameObject();
        // mergeManager.addComponent(new MergeManagerScript(mergeManager, peanutButter, jelly, mergedPeanutButterJelly));
        // rootNode.addChild(mergeManager);


        // collision manager
        GameObject collisionManager = new GameObject();
        collisionManager.addComponent(new CollisionManagerScript(collisionManager, peanutButter, jelly, mergedPeanutButterJelly, tilesContainer, this, starCount));
        rootNode.addChild(collisionManager);

        // //game manager
        // GameObject gameManager = new GameObject();
        // gameManager.addComponent(new GameManagerScript(gameManager, spaceShip, laserPool, asteroidContainer, this));
        // rootNode.addChild(gameManager);
    }
}