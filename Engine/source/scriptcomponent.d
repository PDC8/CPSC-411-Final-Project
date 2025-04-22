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

class PeanutButterScript : ScriptComponent{
    int h_velocity = 0;
    int h_acceleration = 1;
    int h_friction = 1;
    int h_maxSpeed = 2;

    int v_velocity = 0;
    int jumpVelocity = -5;
    int gravity = 1;
    int v_maxSpeed = 5;


    bool isJump = false;
    int direction = 0; //0: for idle, -1: for left, 1: for right

    int dx;
    int dy;

    this(GameObject owner){
		super(owner);
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
            
            // Temporary ground check- TODO: change later when platorm tiling is implemented
            if (transform.y > 100) {
                transform.y = 100;
                v_velocity = 0;
            }

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
            isJump = false;
            direction = 0;

        }
    }
}

// class LaserScript : ScriptComponent {
//     float speed = 5.0f;
//     float lifeTime = 3.0f;
//     float startTime = 0.0f;

//     this(GameObject owner){
// 		super(owner);
//     }

//     override void Update() {
//         auto currentTime = SDL_GetTicks() / 1000.0f;
//         if(currentTime - startTime > lifeTime){
//             mOwner.isActive = false;
//         }

//         auto transform = mOwner.getComponent!TransformComponent();

//         float transformRad = transform.angle * (PI / 180.0f);

//         auto dx = (sin(transformRad) * speed).to!int;
//         auto dy = (cos(transformRad) * speed).to!int;

//         transform.x += dx;
//         transform.y -= dy;
//     }

//     override void Render(){
//         auto animated = mOwner.getComponent!AnimatedTextureComponent();
//         if(animated is null){
//             return;
//         }
//         else{
//             animated.StillAnimation("laser");
//         }
//     }

//     void autoPool(){
//         startTime = SDL_GetTicks() / 1000.0f;
//     }
// }


// class PoolManagerScript : ScriptComponent {
//     LaserPool laserPool;
//     this(GameObject owner, LaserPool laserPool){
// 		super(owner);
//         this.laserPool = laserPool;
//     }

//     override void Update() {
//         foreach(laser; laserPool.lasers){
//             laser.Update();
//         }
//     }

//     override void Render(){
//         foreach(laser; laserPool.lasers){
//             laser.Render();
//         }
//     }
// }

// class AsteroidScript : ScriptComponent{
//     int speed;
//     int size;
//     int type;
//     float dir;
//     this(GameObject owner, int speed, int size, int asteroidType, int direction, int rotation){
// 		super(owner);
//         this.speed = speed;
//         this.size = size;
//         type = asteroidType;
//         dir = direction * (PI / 180.0f);

//         //set asteroid rotation
//         auto transform = mOwner.getComponent!TransformComponent();
//         transform.angle = rotation;
//     }

//     override void Update() {
//         if(size <= 8){
//             mOwner.isActive = false;
//         }

//         auto transform = mOwner.getComponent!TransformComponent();

//         auto dx = (sin(dir) * speed).to!int;
//         auto dy = (cos(dir) * speed).to!int;

//         transform.x += dx;
//         transform.y -= dy;

//         // Wrap around screen boundaries
//         transform.x = ((transform.x % 1920) + 1920) % 1920;
//         transform.y = ((transform.y % 1080) + 1080) % 1080;
//     }

//     override void Render(){
//         auto animated = mOwner.getComponent!AnimatedTextureComponent();
//         if(animated is null){
//             return;
//         }
//         else{
//             if(type){
//                 animated.StillAnimation("asteroid1");
//             }
//             else{
//                 animated.StillAnimation("asteroid2");
//             }
//         }
//     }

//     void split(){
//         size /= 2;

//         auto transform = mOwner.getComponent!TransformComponent();
//         transform.w /= 2;
//         transform.h /= 2;
//     }
// }

// class CameraScript : ScriptComponent{
//     GameObject mTarget;

//     this(GameObject owner, GameObject target){
//         super(owner);
//         mTarget = target;
//     }

//     override void Update() {
//         auto targetScript = mTarget.getComponent!SpaceShipScript();
//         auto cameraTransform = mOwner.getComponent!TransformComponent();

//         auto dx = -targetScript.dx;
//         auto dy = -targetScript.dy;
//         cameraTransform.updatePosition(dx, dy);
//     }
// }

// class WorldContainerScript : ScriptComponent {
//     this(GameObject owner){
//         super(owner);
//     }
//     override void Update() {
//         // Sync with camera's inverse movement
//         auto cameraTransform = mOwner.parent.getComponent!TransformComponent();
//         mOwner.getComponent!TransformComponent().x = -cameraTransform.x;
//         mOwner.getComponent!TransformComponent().y = -cameraTransform.y;
//     }
// }

// class ButtonScript : ScriptComponent{
//     private bool hover;
//     private bool click;
//     private SceneManager sceneManager;
//     this(GameObject owner, SceneManager sceneManager){
//         super(owner);
//         this.sceneManager = sceneManager;
//     }

//     override void Input(){
//         int x;
//         int y;
//         uint mousestate = SDL_GetMouseState(&x, &y);

//         auto transform = mOwner.getComponent!TransformComponent();
//         hover = (transform.x <= x &&
//                  x <= transform.x + transform.w && 
//                  transform.y <= y &&
//                  y <= transform.y + transform.h);
//         click = hover && (mousestate & (1 << (SDL_BUTTON_LEFT - 1)));
//     }

//     override void Update(){
//         if(click){
//             sceneManager.switchScene("Level 1");
//         }
//     }

//     override void Render(){
//         auto animated = mOwner.getComponent!AnimatedTextureComponent();
//         if(animated is null){
//             return;
//         }
//         else{
//             if(hover){
//                 animated.StillAnimation("playButton2");
//             }
//             else{
//                 animated.StillAnimation("playButton1");
//             }
//         }
//     }
// }

// class CollisionManagerScript : ScriptComponent {
//     GameObject spaceShip;
//     LaserPool laserPool;
//     GameObject asteroidContainer;

//     this(GameObject owner, GameObject spaceShip, LaserPool laserPool, GameObject asteroidContainer) {
//         super(owner);
//         this.spaceShip = spaceShip;
//         this.laserPool = laserPool;
//         this.asteroidContainer = asteroidContainer;
//     }

//     override void Update() {
//         // Laser-Asteroid Collisions
//         foreach(laser; laserPool.lasers) {
//             if(laser.isActive) {
//                 foreach(asteroid; asteroidContainer.children) {
//                     if(asteroid.isActive) {
//                         if(checkCollision(laser, asteroid)) {
//                             laser.isActive = false;
//                             asteroid.getComponent!AsteroidScript.split();
//                         }
//                     }
//                 }
//             }
//         }
//         // Spaceship-Asteroid Collisions
//         foreach(asteroid; asteroidContainer.children){
//             if(asteroid.isActive){
//                 foreach(laser; laserPool.lasers){
//                     if(laser.isActive){
//                         if(checkCollision(laser, asteroid)){
//                             laser.isActive = false;
//                             asteroid.isActive = false;
//                         }
//                     }
//                 }

//                 if(checkCollision(spaceShip, asteroid)){
//                     spaceShip.isActive = false;
//                 }
//             }
//         }
//     }

//     bool checkCollision(GameObject obj1, GameObject obj2){
//         auto transform1 = obj1.getComponent!TransformComponent();
//         auto transform2 = obj2.getComponent!TransformComponent();

//         return SDL_HasIntersection(&transform1.mRectangle, &transform2.mRectangle) == SDL_TRUE;
//     }
// }

// class BgScript : ScriptComponent{
//     this(GameObject owner){
//         super(owner);
//     }

//     override void Render(){
//         auto animated = mOwner.getComponent!AnimatedTextureComponent();
//         if(animated is null){
//             return;
//         }
//         else{
//             animated.StillAnimation("background");
//         }
//     }
// }

// class GameManagerScript : ScriptComponent {
//     GameObject spaceShip;
//     LaserPool laserPool;
//     GameObject asteroidContainer;
//     Scene scene;

//     this(GameObject owner, GameObject spaceShip, LaserPool laserPool, GameObject asteroidContainer, Scene scene) {
//         super(owner);
//         this.spaceShip = spaceShip;
//         this.laserPool = laserPool;
//         this.asteroidContainer = asteroidContainer;
//         this.scene = scene;
//     }

//     override void Update() {
//         //if spaceship is inactive
//         if(!spaceShip.isActive){
//             scene.gameOver = true;
//             writeln("Spaceship destroyed!");
//         }
//         int count = 0;
//         foreach(asteroid; asteroidContainer.children){
//             if(!asteroid.isActive){
//                 count += 1;
//             }
//         }
//         if(count == asteroidContainer.children.length){
//             scene.gameOver = true;
//             writeln("All asteroids destroyed!");
//         }
//     }
// }