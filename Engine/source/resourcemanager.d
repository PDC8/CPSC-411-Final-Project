import std.stdio, std.container, std.string, std.json, std.algorithm, std.conv, std.string;;
import bindbc.sdl;
import frame;

class ResourceManager{

    struct AnimationData{
        Frame[] mFrames;
        long[][string] mFrameNumbers;
    }

    struct TileMap {
        int width;
        int height;
        int[2] pb_spawn;
        int[2] j_spawn;
        string[][] tiles;
    }

    static ResourceManager GetInstance(){
        if(mInstance is null){
            mInstance = new ResourceManager();
        }
        return mInstance;
    }

    static TileMap LoadTileMap(string filename) {
        auto file    = File(filename, "r");
        auto content = file.byLine.joiner("\n");
        auto j       = parseJSON(content);

        TileMap mapData;
        mapData.width  = j["width"].integer.to!int;
        mapData.height = j["height"].integer.to!int;

        auto pb = j["pb_spawn"].array;
        mapData.pb_spawn = [pb[0].integer.to!int, pb[1].integer.to!int];

        auto js = j["j_spawn"].array;
        mapData.j_spawn = [js[0].integer.to!int, js[1].integer.to!int];

        auto rows = j["tiles"].array;
        mapData.tiles = new string[][](mapData.height);

        foreach(r, rowVal; rows) {
            auto cols = rowVal.array;
            mapData.tiles[r] = new string[](cols.length);
            foreach(c, cellVal; cols) {
                if (cellVal.type == JSONType.NULL)
                    mapData.tiles[r][c] = "";
                else
                    mapData.tiles[r][c] = cellVal.str; 
            }
        }
        return mapData;
    }

    // static Music LoadMusic(string filename){
    //     if(filename in musicMap){
    //         return musicMap[filename];
    //     }
    //     else{
    //         musicMap[filename] = Music(filename);
    //         return musicMap[filename];
    //     }
    // } 

    static SDL_Texture* LoadTexture(SDL_Renderer* renderer, string filename){
        if(filename in textureMap){
            return textureMap[filename];
        }
        // else if(filename == "create_nums"){
        //     SDL_Color white = {0, 0, 0, 255};
        //     TTF_Font* font = TTF_OpenFont("./assets/font.ttf", 24);
        //     for(int i = 0; i < 10; i++){
        //         string num_str = i.to!string;
        //         SDL_Surface* surface = TTF_RenderText_Solid(font, num_str.toStringz, white);
        //         SDL_Texture* texture = SDL_CreateTextureFromSurface(renderer, surface);
        //         SDL_FreeSurface(surface);
        //         textureMap[num_str] = texture;
        //     }
        //     return textureMap["0"];
        // }
        else{
            SDL_Surface* surface = SDL_LoadBMP(filename.toStringz);
            SDL_Texture* texture = SDL_CreateTextureFromSurface(renderer, surface);
            SDL_FreeSurface(surface);
            textureMap[filename] = texture;
            return texture;
        }
    } 

    static AnimationData LoadAnimationData(string filename){
        if(filename in animationMap){
            return animationMap[filename];
        }
        else{
            AnimationData data;
            auto file = File(filename, "r");
            auto jsonFileContents = file.byLine.joiner("\n");
            auto j = parseJSON(jsonFileContents);

            int height = j["format"]["height"].integer.to!int;
            int width = j["format"]["width"].integer.to!int;
            int tileH = j["format"]["tileHeight"].integer.to!int;
            int tileW = j["format"]["tileWidth"].integer.to!int;

            int num_cols = width / tileW;
            int num_rows = height / tileH;

            data.mFrames.length = num_rows * num_cols;
            foreach(dir; j["frames"].object.keys()){
                foreach(index; j["frames"][dir].array){
                    auto idx = index.integer.to!int;
                    auto x = (idx % num_cols) * tileW;
                    auto y = (idx / num_cols) * tileH;
                    data.mFrames[idx] = Frame(SDL_Rect(x, y, tileW, tileH));

                    data.mFrameNumbers[dir] ~= idx;
                }
            }
            animationMap[filename] = data;
            return data;
        }
    }


    private:
        static SDL_Texture* [string] textureMap;
        static AnimationData [string] animationMap;
        // static Music[string] musicMap;
        static ResourceManager mInstance;
         
}
