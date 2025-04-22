import bindbc.sdl;
import gameobject;
import std.stdio;

struct SceneTree{
    GameObject mRoot;

    void setRoot(GameObject node){
        mRoot = node;
    }

    void Input(){
        if(mRoot !is null && mRoot.isActive){
            mRoot.Input();
        }
    }

    void Update(){
        if(mRoot !is null && mRoot.isActive){
            mRoot.Update();
        }
    }

    void Render(){
        if(mRoot !is null && mRoot.isActive){
            mRoot.Render();
        }
    }
}