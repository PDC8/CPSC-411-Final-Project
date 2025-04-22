import bindbc.sdl, std.stdio;
import scene;

class SceneManager{
    private:
        Scene[string] queuedScenes;
    public:
        Scene currentScene;
        SDL_Renderer* renderer;

    this(SDL_Renderer* renderer){
        this.renderer = renderer;
        initSceneManager();
    }

    void initSceneManager(){
        Scene mainMenuScene = new MainMenu(renderer, this, "./assets/Assets.bmp", "./assets/Assets.json");
        Scene level1Scene = new Level1(renderer, this, "./assets/Assets.bmp", "./assets/Assets.json");
        this.addScene("Main Menu", mainMenuScene);
        this.addScene("Level 1", level1Scene);
    }

    void switchScene(string sceneName){
        if(sceneName in queuedScenes){
            currentScene = queuedScenes[sceneName];
        }
        else{
            writeln("Error: Scene doesn't exist");
        }
    }

    void addScene(string sceneName, Scene newScene){
        queuedScenes[sceneName] = newScene;
    }
}