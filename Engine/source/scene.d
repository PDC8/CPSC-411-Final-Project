import bindbc.sdl, std.random, std.stdio;
import scenetree, gameobject, component, scriptcomponent, scenemanager;
import resourcemanager;

enum TILESIZE = 32; 

abstract class Scene{
    SceneTree tree;
    SDL_Renderer* renderer;
    SceneManager sceneManager;
    bool gameOver = false;
    this(SDL_Renderer* renderer, SceneManager sceneManager){
        this.renderer = renderer;
        this.sceneManager = sceneManager;
    }
    void setUpScene(string image, string data);
}

class MainMenu : Scene{
    immutable int size = 200;
    int buttonX = 320 - (size / 2);
    int buttonY = 240 - (size / 2);
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


class Level1 : Scene{
    int PB_X = 0;
    int PB_Y = 100;
    int J_X = 100;
    int J_Y = 100;
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
        auto tm = ResourceManager.GetInstance().LoadTileMap("./assets/maps/map.json");
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
            }
        }

        // //background object
        // GameObject bg = new GameObject();
        // bg.addComponent(new TransformComponent(bg, 0, 0, 640, 640));
        // bg.addComponent(new TextureComponent(bg, renderer, "./assets/Background.bmp"));
        // bg.addComponent(new AnimatedTextureComponent(bg, renderer, "./assets/Background.json"));
        // bg.addComponent(new BgScript(bg));
        // rootNode.addChild(bg);


        // //camera object
        // GameObject camera = new GameObject();
        // camera.addComponent(new TransformComponent(camera, 0, 0, 0, 0));
        // camera.addComponent(new CameraScript(camera, spaceShip));
        // rootNode.addChild(camera);

        // //worldContainer
        // GameObject worldContainer = new GameObject();
        // worldContainer.addComponent(new TransformComponent(worldContainer, 0, 0, 0, 0)); //allow transform inheritance
        // worldContainer.addComponent(new WorldContainerScript(worldContainer));
        // camera.addChild(worldContainer);


        //set up peanut butter object
        GameObject peanutButter = new GameObject();
        peanutButter.addComponent(new TransformComponent(peanutButter, PB_X, PB_Y, 32, 32));
        peanutButter.addComponent(new TextureComponent(peanutButter, renderer, image));
        peanutButter.addComponent(new AnimatedTextureComponent(peanutButter, renderer, data));
        peanutButter.addComponent(new PeanutButterScript(peanutButter));
        rootNode.addChild(peanutButter);

        //set up jelly object
        GameObject jelly = new GameObject();
        jelly.addComponent(new TransformComponent(jelly, J_X, J_Y, 32, 32));
        jelly.addComponent(new TextureComponent(jelly, renderer, image));
        jelly.addComponent(new AnimatedTextureComponent(jelly, renderer, data));
        jelly.addComponent(new JellyScript(jelly));
        rootNode.addChild(jelly);


        // collision manager
        GameObject collisionManager = new GameObject();
        collisionManager.addComponent(new CollisionManagerScript(collisionManager, peanutButter, jelly, tilesContainer));
        rootNode.addChild(collisionManager);

        // //game manager
        // GameObject gameManager = new GameObject();
        // gameManager.addComponent(new GameManagerScript(gameManager, spaceShip, laserPool, asteroidContainer, this));
        // rootNode.addChild(gameManager);
    }
}