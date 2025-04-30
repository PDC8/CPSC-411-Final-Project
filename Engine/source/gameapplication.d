import std.stdio, std.string, std.conv;
import bindbc.sdl;
import sdl_abstraction, gameapplication, gameobject, component, scriptcomponent, scenemanager;

struct GameApplication{
    SDL_Window* mWindow = null;
    SDL_Renderer* mRenderer = null;
    bool mGameIsRunning = true;

    SceneManager sceneManager;
    
    // Constructor
    this(string title){
        // Create an SDL window
        mWindow = SDL_CreateWindow(title.toStringz, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 800, 640, SDL_WINDOW_SHOWN);
        // Create a hardware accelerated mRenderer
        mRenderer = SDL_CreateRenderer(mWindow,-1,SDL_RENDERER_ACCELERATED);

        sceneManager = new SceneManager(mRenderer);
    }

    // Destructor
    ~this(){
        // Destroy our renderer
        SDL_DestroyRenderer(mRenderer);
        // Destroy our window
        SDL_DestroyWindow(mWindow);
    }

    // Handle input
    void Input(){
        SDL_Event event;
        // Start our event loop
        while(SDL_PollEvent(&event)){
            // Handle each specific event
            if(event.type == SDL_QUIT){
                mGameIsRunning= false;
            }
        }
        sceneManager.currentScene.tree.Input();
    }

    void Update(){
        sceneManager.currentScene.tree.Update();
    }

    void Render(){
        // Set the render draw color 
        SDL_SetRenderDrawColor(mRenderer,100,190,255,SDL_ALPHA_OPAQUE);

        // Clear the renderer each time we render
        SDL_RenderClear(mRenderer);

        sceneManager.currentScene.tree.Render();

        // Final step is to present what we have copied into
        // video memory
        SDL_RenderPresent(mRenderer);
    }

    void isGameOver(){
        if(sceneManager.currentScene.gameOver){
            mGameIsRunning = false;
        }
    }

    // Advance world one frame at a time
    void AdvanceFrame(){

        auto start = SDL_GetTicks();
        Input();
        Update();
        Render();
        isGameOver();

        auto timePassed = SDL_GetTicks() - start;
        if(timePassed < 16){
        	SDL_Delay(16 - timePassed);
        } 
    }

    void RunLoop(){
        // Main application loop
        sceneManager.switchScene("Main Menu");
        while(mGameIsRunning){
            AdvanceFrame();	
        }
    }
}
