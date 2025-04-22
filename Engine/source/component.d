import std.stdio, std.string, std.algorithm, std.conv, std.array, std.json, std.math;
import bindbc.sdl;
import gameobject, resourcemanager, frame, scriptcomponent;


abstract class IComponent{
    GameObject mOwner; 
}

// Transform component
class TransformComponent : IComponent{
    SDL_Rect mRectangle;
    alias mRectangle this;

    float angle = 0.0;
    // bool isRotate = false;
    // int duration = 24;

    this(GameObject owner, int _x, int _y, int _w, int _h){
        mOwner = owner;

        // Initial rectangle position 
        mRectangle.x = _x;
        mRectangle.y = _y;
        mRectangle.w = _w;
        mRectangle.h = _h;
    }

    void updatePosition(int dx, int dy) {
        mRectangle.x += dx;
        mRectangle.y += dy;
        // Propagate to children
        foreach (child; mOwner.children) {
            auto childTransform = child.getComponent!TransformComponent();
            if (childTransform !is null) {
                childTransform.updatePosition(dx, dy);
            }
        }
    }
}

// Texture Component
class TextureComponent : IComponent{
    SDL_Texture* mTexture;
    alias mTexture this;
    SDL_Renderer* renderer;

    this(GameObject owner, SDL_Renderer* renderer, string bitmapFilePath){
        mOwner = owner;
        if(bitmapFilePath != ""){
            mTexture = ResourceManager.GetInstance.LoadTexture(renderer, bitmapFilePath);
            this.renderer = renderer;
        }
    }

    ~this(){
        SDL_DestroyTexture(mTexture);
    }
}


/// Store a series of frames and multiple animation sequences that can be played
class AnimatedTextureComponent : IComponent{
    string mFilename;

    Frame[] mFrames;

    long[][string] mFrameNumbers;

	// Helpers for references to data
    SDL_Renderer* mRendererRef;
    TextureComponent mTextureRef;
    TransformComponent mTransformRef;

    // Stateful information about the current animation
    // sequene that is playing
    string mCurrentAnimationName; // Which animation is currently playing
    long mCurrentFramePlaying ;   // Current frame that is playing, an index into 'mFrames'
    long mLastFrameInSequence;

    // Time delay between frames
    long mFrameDelay = 100; // 100ms
    long mLastFrameTime = 0;

    this(GameObject owner, SDL_Renderer* r, string filename){
		mOwner = owner;
        mFilename = filename;
        mRendererRef = r;
        mTextureRef = getTextureComponent();
        mTransformRef = getTransformComponent();

        if(filename != ""){
            mFrames = ResourceManager.GetInstance.LoadAnimationData(filename).mFrames;
            mFrameNumbers = ResourceManager.GetInstance.LoadAnimationData(filename).mFrameNumbers;
        }
    }
    
    // Play an animation based on the name of the animation sequence
    // specified in the data file.
    void LoopAnimationSequence(string name){
        auto currentTime = SDL_GetTicks();

        if(currentTime - mLastFrameTime > mFrameDelay) {
            mLastFrameTime = currentTime;

            if (mCurrentAnimationName != name) {
                mCurrentAnimationName = name;
                mCurrentFramePlaying = mFrameNumbers[name][0];
                mLastFrameInSequence = mFrameNumbers[name].back();
            }
            else{
                auto temp = mCurrentFramePlaying;
                if(mCurrentFramePlaying == mLastFrameInSequence){
                    mCurrentFramePlaying = mLastFrameInSequence - (mFrameNumbers[name].length - 1);
                }
                else{
                    mCurrentFramePlaying += 1;
                }
            }
        }
        // Get the current frame's rectangle (from sprite sheet)
        SDL_Rect currentFrameRect = mFrames[mCurrentFramePlaying].mRect;

        // Render the texture at the position and size defined in the current frame's rectangle
        SDL_RenderCopyEx(mRendererRef, mTextureRef, &currentFrameRect, &mTransformRef.mRectangle, mTransformRef.angle, null, SDL_FLIP_NONE);
    }

    void StillAnimation(string name){
        mCurrentAnimationName = name;
        mCurrentFramePlaying = mFrameNumbers[name][0];
        mLastFrameInSequence = mFrameNumbers[name].back();
        // Get the current frame's rectangle (from sprite sheet)
        SDL_Rect currentFrameRect = mFrames[mCurrentFramePlaying].mRect;

        // Render the texture at the position and size defined in the current frame's rectangle
        SDL_RenderCopyEx(mRendererRef, mTextureRef, &currentFrameRect, &mTransformRef.mRectangle, mTransformRef.angle, null, SDL_FLIP_NONE);
    }

    private TextureComponent getTextureComponent() {
        return mOwner.getComponent!TextureComponent();
    }

    private TransformComponent getTransformComponent() {
        return mOwner.getComponent!TransformComponent();
    }
}