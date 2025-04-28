import std.stdio, std.algorithm, std.conv, std.array;
import bindbc.sdl;
import component, scriptcomponent;


/// The sprite class which is a 'moveable image'
class GameObject{
	// Scene Tree
	GameObject parent;
	GameObject[] children;

	// Components 
	IComponent[string] mComponents;
	bool isActive = true;
	string scriptType = ""; // Used for movement mixins 

	// Destructor
	~this(){
	}

	// Add component dynamically
	void addComponent(IComponent component) {
		component.mOwner = this;
		mComponents[component.classinfo.name] = component;
	}

	// Get component by type
	T getComponent(T)() {
		foreach (name, component; mComponents) {
			if (cast(T) component) {
				return cast(T) component;
			}
		}
		return null;
	}

	// Add children
	void addChild(GameObject child){
		child.parent = this;
		children ~= child;
	}

	void Input(){
		auto behaviorScript = getComponent!ScriptComponent();
		if(isActive){
			if(behaviorScript){
				behaviorScript.Input();
			}
			foreach(child; children){
				child.Input();
			}
		}
	}

	void Update(){
		auto behaviorScript = getComponent!ScriptComponent();
		if(isActive){
			if(behaviorScript){
				behaviorScript.Update();
			}
			foreach(child; children){
				child.Update();
			}
		}
	}

	void Render(){
		auto behaviorScript = getComponent!ScriptComponent();
		if(isActive){
			if(behaviorScript){
				behaviorScript.Render();
			}
			foreach(child; children){
				child.Render();
			}
		}
	}
}
