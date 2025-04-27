import bindbc.sdl;
import std.stdio, std.math, std.random, std.conv, std.string, std.algorithm;
import component, gameobject, gameapplication, resourcemanager, scenemanager, scene;


class ScriptComponent : IComponent{
    this(GameObject owner){
		mOwner = owner;
    }
    void Input(){
    }
    void Update(){
    }
    void Render(){
    }
}

class MovementScript : ScriptComponent{
    int h_velocity = 0;
    int h_acceleration = 1;
    int h_friction = 1;
    int h_maxSpeed = 2;

    int v_velocity = 0;
    int jumpVelocity = -12;
    int gravity = 1;
    int v_maxSpeed = 5;

    bool isJump = false;
    int direction = 0; //0: for idle, -1: for left, 1: for right

    int dx;
    int dy;

    this(GameObject owner){
        super(owner);
    }
}



class PeanutButterScript : MovementScript{
    this(GameObject owner){
		super(owner);
        this.jumpVelocity = -12;
    }
    override void Input(){
        ubyte* keystate = SDL_GetKeyboardState(null);

        if(keystate[SDL_SCANCODE_A]){
            direction = -1;
            h_velocity += h_acceleration;
        }
        else if(keystate[SDL_SCANCODE_D]){
            direction = 1;
            h_velocity += h_acceleration;
        }
        if (keystate[SDL_SCANCODE_W]){
            if(isJump){
                return;
            }
            v_velocity = jumpVelocity;
            isJump = true;
        }	
    }
    override void Update(){
        auto transform = mOwner.getComponent!TransformComponent();
        if(transform !is null){

            if (direction == 0) {
                h_velocity -= h_friction;
                if (h_velocity < 0) h_velocity = 0;
            }
            h_velocity = min(h_velocity, h_maxSpeed);

            v_velocity += gravity;
            v_velocity = min(v_velocity, v_maxSpeed);

            dx = direction * h_velocity;
            dy = v_velocity;
            transform.x += dx;
            transform.y += dy;
        }
    }
    override void Render(){
        auto animated = mOwner.getComponent!AnimatedTextureComponent();
        if(animated is null){
            return;
        }
        else{
            if(direction == 0){
                if(isJump){
                    animated.LoopAnimationSequence("p_idle_jump");
                }
                else{
                    animated.LoopAnimationSequence("p_idle");
                }
            }
            else if(direction == -1){
                if(isJump){
                    animated.LoopAnimationSequence("p_jump_left");
                }
                else{
                    animated.LoopAnimationSequence("p_run_left");
                }
            }
            else if(direction == 1){
                if(isJump){
                    animated.LoopAnimationSequence("p_jump_right");
                }
                else{
                    animated.LoopAnimationSequence("p_run_right");
                }
            }
        }
        direction = 0;
    }
}


class JellyScript : MovementScript{
    this(GameObject owner){
		super(owner);
        this.jumpVelocity = -12;
    }
    override void Input(){
        ubyte* keystate = SDL_GetKeyboardState(null);

        if(keystate[SDL_SCANCODE_LEFT]){
            direction = -1;
            h_velocity += h_acceleration;
        }
        else if(keystate[SDL_SCANCODE_RIGHT]){
            direction = 1;
            h_velocity += h_acceleration;
        }
        if (keystate[SDL_SCANCODE_UP]){
            if(isJump){
                return;
            }
            v_velocity = jumpVelocity;
            isJump = true;
        }	
    }
    override void Update(){
        auto transform = mOwner.getComponent!TransformComponent();
        if(transform !is null){

            if (direction == 0) {
                h_velocity -= h_friction;
                if (h_velocity < 0) h_velocity = 0;
            }
            h_velocity = min(h_velocity, h_maxSpeed);

            v_velocity += gravity;
            v_velocity = min(v_velocity, v_maxSpeed);

            dx = direction * h_velocity;
            dy = v_velocity;
            transform.x += dx;
            transform.y += dy;
        }
    }
    override void Render(){
        auto animated = mOwner.getComponent!AnimatedTextureComponent();
        if(animated is null){
            return;
        }
        else{
            if(direction == 0){
                if(isJump){
                    animated.LoopAnimationSequence("j_idle_jump");
                }
                else{
                    animated.LoopAnimationSequence("j_idle");
                }
            }
            else if(direction == -1){
                if(isJump){
                    animated.LoopAnimationSequence("j_jump_left");
                }
                else{
                    animated.LoopAnimationSequence("j_run_left");
                }
            }
            else if(direction == 1){
                if(isJump){
                    animated.LoopAnimationSequence("j_jump_right");
                }
                else{
                    animated.LoopAnimationSequence("j_run_right");
                }
            }
        }
        direction = 0;
    }
}

class MergedPeanutButterJellyScript : MovementScript{
    this(GameObject owner){
		super(owner);
        this.jumpVelocity = -15;
    }
    override void Input(){
        ubyte* keystate = SDL_GetKeyboardState(null);

        if(keystate[SDL_SCANCODE_A]){
            direction = -1;
            h_velocity += h_acceleration;
        }
        else if(keystate[SDL_SCANCODE_D]){
            direction = 1;
            h_velocity += h_acceleration;
        }
        if (keystate[SDL_SCANCODE_UP]){
            if(isJump){
                return;
            }
            v_velocity = jumpVelocity;
            isJump = true;
        }	
    }
    override void Update(){
        auto transform = mOwner.getComponent!TransformComponent();
        if(transform !is null){

            if (direction == 0) {
                h_velocity -= h_friction;
                if (h_velocity < 0) h_velocity = 0;
            }
            h_velocity = min(h_velocity, h_maxSpeed);

            v_velocity += gravity;
            v_velocity = min(v_velocity, v_maxSpeed);

            dx = direction * h_velocity;
            dy = v_velocity;
            transform.x += dx;
            transform.y += dy;
        }
    }
    override void Render(){
        auto animated = mOwner.getComponent!AnimatedTextureComponent();
        if(animated is null){
            return;
        }
        else{
            if(direction == 0){
                if(isJump){
                    animated.LoopAnimationSequence("pbj_idle_jump");
                }
                else{
                    animated.LoopAnimationSequence("pbj_idle");
                }
            }
            else if(direction == -1){
                if(isJump){
                    animated.LoopAnimationSequence("pbj_jump_left");
                }
                else{
                    animated.LoopAnimationSequence("pbj_run_left");
                }
            }
            else if(direction == 1){
                if(isJump){
                    animated.LoopAnimationSequence("pbj_jump_right");
                }
                else{
                    animated.LoopAnimationSequence("pbj_run_right");
                }
            }
        }
        direction = 0;
    }
}

class ButtonScript : ScriptComponent{
    private bool hover;
    private bool click;
    private SceneManager sceneManager;
    this(GameObject owner, SceneManager sceneManager){
        super(owner);
        this.sceneManager = sceneManager;
    }

    override void Input(){
        int x;
        int y;
        uint mousestate = SDL_GetMouseState(&x, &y);

        auto transform = mOwner.getComponent!TransformComponent();
        hover = (transform.x <= x &&
                 x <= transform.x + transform.w && 
                 transform.y <= y &&
                 y <= transform.y + transform.h);
        click = hover && (mousestate & (1 << (SDL_BUTTON_LEFT - 1)));
    }

    override void Update(){
        if(click){
            sceneManager.switchScene("Level 1");
        }
    }

    override void Render(){
        auto animated = mOwner.getComponent!AnimatedTextureComponent();
        if(animated is null){
            return;
        }
        else{
            if(hover){
                animated.StillAnimation("play_button_2");
            }
            else{
                animated.StillAnimation("play_button_1");
            }
        }
    }
}

class TileScript : ScriptComponent {
    public string tileType;
    this(GameObject owner, string tileType) {
        super(owner);
        this.tileType = tileType;
    }

    override void Render() {
        auto animated = mOwner.getComponent!AnimatedTextureComponent();
        if(animated is null){
            return;
        }
        animated.StillAnimation(tileType);
    }
}

class CollisionManagerScript : ScriptComponent {
    GameObject peanutButter;
    GameObject jelly;
    GameObject tilesContainer;
    GameObject mergedPeanutButterJelly;
    bool isMerged = false;
    bool isSpacePressed = false;
    uint prevTransitionTime = 0;
    Level1 level1Scene;
    int starCount; 
    int playerCount = 2;

    this(GameObject owner, GameObject peanutButter, GameObject jelly, GameObject mergedPeanutButterJelly, GameObject tilesContainer, Level1 level1Scene, int starCount) {
        super(owner);
        this.peanutButter = peanutButter;
        this.jelly = jelly;
        this.mergedPeanutButterJelly = mergedPeanutButterJelly;
        this.tilesContainer = tilesContainer;
        this.level1Scene = level1Scene;
        this.starCount = starCount; 
    }

    override void Input() {
        ubyte* keystate = SDL_GetKeyboardState(null);
        if(keystate[SDL_SCANCODE_SPACE]){
            isSpacePressed = true;
        } else {
            isSpacePressed = false;
        }
    }

    override void Update() {
        foreach(tile; tilesContainer.children){
            checkPlayerTileCollision(peanutButter, tile);
            checkPlayerTileCollision(jelly, tile);
            checkPlayerTileCollision(mergedPeanutButterJelly, tile);
        }

        // peanutButter-jelly Collisions
        if(checkCollision(peanutButter, jelly)){
            if(!isSpacePressed)
                return;

            auto currTime = SDL_GetTicks();
            if (currTime - prevTransitionTime < 500)
                return;

            auto pbTransform = peanutButter.getComponent!TransformComponent();
            auto jTransform = jelly.getComponent!TransformComponent();
            auto mergedTransform = mergedPeanutButterJelly.getComponent!TransformComponent();

            if (!isMerged) {
                isMerged = true;
                peanutButter.isActive = false;
                jelly.isActive = false;
                mergedPeanutButterJelly.isActive = true;
                mergedTransform.x = pbTransform.x;
                mergedTransform.y = pbTransform.y;
                prevTransitionTime = currTime;

            } else {
                isMerged = false;
                peanutButter.isActive = true;
                jelly.isActive = true;
                mergedPeanutButterJelly.isActive = false;
                pbTransform.x = mergedTransform.x - 10; // TODO: maybe fix for edge case where you glitch out of bound
                pbTransform.y = mergedTransform.y;
                jTransform.x = mergedTransform.x + 10; // TODO: same as above
                jTransform.y = mergedTransform.y;
                prevTransitionTime = currTime;
            }
        }
    }

    bool checkCollision(GameObject obj1, GameObject obj2){
        auto transform1 = obj1.getComponent!TransformComponent();
        auto transform2 = obj2.getComponent!TransformComponent();

        return SDL_HasIntersection(&transform1.mRectangle, &transform2.mRectangle) == SDL_TRUE;
    }

    void checkPlayerTileCollision(GameObject player, GameObject tile){
        if(tile.isActive){
            auto tileType = tile.getComponent!TileScript().tileType;
            MovementScript playerScript;
            if(player.scriptType == "PeanutButterScript"){
                playerScript = player.getComponent!PeanutButterScript();
            }
            else if(player.scriptType == "JellyScript"){
                playerScript = player.getComponent!JellyScript();
            }
            else if(player.scriptType == "MergedPeanutButterJellyScript"){
                playerScript = player.getComponent!MergedPeanutButterJellyScript();
            }

            if(checkCollision(player, tile)){
                if(tileType == "ground"){
                    groundTile(player, tile, playerScript);
                }

                else if(tileType == "jelly_ground"){ //jelly tile
                    groundTile(player, tile, playerScript);
                    if(player.id != 1){ //peanut butter
                        playerScript.h_velocity = 0;
                        playerScript.isJump = true;
                    }
                }
                else if (tileType == "pb_ground"){ //pb tile
                    groundTile(player, tile, playerScript);
                    if(player.id != 0){ //jelly
                        playerScript.h_velocity = 0;
                        playerScript.isJump = true;
                    }
                }
                else if(tileType == "obstacle"){ //obstacle tile
                    if(player.isActive) {
                        playerCount -= 1;
                        if(playerCount == 0) {
                            SceneManager.currentScene.gameOver = true;
                        }
                    }
                    player.isActive = false;
                } else if(tileType == "star") { //star tile
                    if(tile.isActive) {
                        starCount -= 1; 
                        if(starCount == 0) {
                            SceneManager.currentScene.win = true;
                            SceneManager.currentScene.gameOver = true;
                        }
                    }
                    tile.isActive = false; 
                }
            }
        }
    }


    void groundTile(GameObject player, GameObject tile, MovementScript playerScript){
        auto transform = player.getComponent!TransformComponent();
        auto tileTransform = tile.getComponent!TransformComponent();
        if(transform.y < tileTransform.y){ //colision from above
            transform.y = tileTransform.y - transform.h;
            playerScript.v_velocity = 0;
            playerScript.isJump = false;
        }
        else if(transform.y > tileTransform.y){ //colision from below
            transform.y = tileTransform.y + tileTransform.h;
            playerScript.v_velocity = 0;
        }
        else if (transform.x + transform.w > tileTransform.x && transform.x < tileTransform.x) { //collision from left
            transform.x = tileTransform.x - transform.w; // prevent overlap from the left
            transform.y -= transform.h; //prevent phasing down through tile
            playerScript.h_velocity = 0;
            // playerScript.isJump = false; //allow for double jump off side wall
        }
        else if(transform.x > tileTransform.x + 10){ //colision from right
            transform.x = tileTransform.x + transform.w;
            transform.y -= transform.h; //prevent phasing down through tile
            playerScript.h_velocity = 0;
            // playerScript.isJump = false; //allow for double jump off side wall
        }
    }
}

class BgScript : ScriptComponent{
    this(GameObject owner){
        super(owner);
    }

    override void Render(){
        auto animated = mOwner.getComponent!AnimatedTextureComponent();
        if(animated is null){
            return;
        }
        else{
            animated.StillAnimation("background");
        }
    }
}