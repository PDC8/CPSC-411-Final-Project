import tkinter as tk
from tkinter import filedialog as fd
from PIL import Image, ImageTk, ImageDraw
import json

TILESIZE   = 32
MAP_COLS   = 50
MAP_ROWS   = 30
TILE_TYPES = ['ground', 'obstacle', 'ladder']

class TileMapEditor:
    def __init__(self, gui):
        self.gui = gui
        gui.title("2D Tile Map Editor")

        self.selected_tile = TILE_TYPES[0]
        self.tile_images = {}

        self.left_frame = tk.Frame(gui)
        self.left_frame.pack(side=tk.LEFT, padx=10, pady=10)
        self.right_frame = tk.Frame(gui)
        self.right_frame.pack(side=tk.RIGHT, padx=10, pady=10)

        self.create_tile_images()

        self.atlas_canvas = tk.Canvas(
            self.left_frame,
            width=len(TILE_TYPES)*TILESIZE,
            height=TILESIZE
        )
        self.atlas_canvas.pack()
        self.draw_atlas()
        self.atlas_canvas.bind("<Button-1>", self.atlas_click)

        btn_save = tk.Button(self.left_frame, text="Save Map", command=self.save_map)
        btn_save.pack(pady=(10,0))
        btn_load = tk.Button(self.left_frame, text="Load Map", command=self.load_map)
        btn_load.pack(pady=(5,0))

        self.map_canvas = tk.Canvas(
            self.right_frame,
            width=MAP_COLS*TILESIZE,
            height=MAP_ROWS*TILESIZE,
            bg="white"
        )
        self.map_canvas.pack()
        self.draw_grid()
        self.map_canvas.bind("<Button-1>", self.map_click)
        self.map_canvas.bind("<B1-Motion>", self.map_drag)

        self.tilemap = [[None for _ in range(MAP_COLS)] for _ in range(MAP_ROWS)]

    def create_tile_images(self):
        for ttype in TILE_TYPES:
            img = Image.new("RGBA", (TILESIZE, TILESIZE), (0,0,0,0))
            draw = ImageDraw.Draw(img)
            if ttype == 'ground':
                color = (34,139,34)    # forest green
            elif ttype == 'obstacle':
                color = (139,69,19)    # brown
            elif ttype == 'ladder': 
                color = (0,0,0) # black
            draw.rectangle([0,0,TILESIZE,TILESIZE], fill=color, outline="black")
            self.tile_images[ttype] = ImageTk.PhotoImage(img)

    def draw_atlas(self):
        self.atlas_canvas.delete("all")
        for idx, ttype in enumerate(TILE_TYPES):
            img = self.tile_images[ttype]
            self.atlas_canvas.create_image(idx*TILESIZE, 0,
                                           image=img, anchor='nw')
            if ttype == self.selected_tile:
                self.atlas_canvas.create_rectangle(
                    idx*TILESIZE, 0,
                    (idx+1)*TILESIZE, TILESIZE,
                    outline="red", width=2
                )

    def atlas_click(self, event):
        idx = event.x // TILESIZE
        if 0 <= idx < len(TILE_TYPES):
            self.selected_tile = TILE_TYPES[idx]
            self.draw_atlas()

    def draw_grid(self):
        for i in range(MAP_COLS+1):
            x = i*TILESIZE
            self.map_canvas.create_line(x, 0, x, MAP_ROWS*TILESIZE, fill="gray")
        for j in range(MAP_ROWS+1):
            y = j*TILESIZE
            self.map_canvas.create_line(0, y, MAP_COLS*TILESIZE, y, fill="gray")

    def map_click(self, event):
        self.place_tile(event)

    def map_drag(self, event):
        self.place_tile(event)

    def place_tile(self, event):
        c, r = event.x // TILESIZE, event.y // TILESIZE
        if 0 <= c < MAP_COLS and 0 <= r < MAP_ROWS:
            self.tilemap[r][c] = self.selected_tile
            tag = f"tile_{r}_{c}"
            # remove existing at this cell, then draw
            self.map_canvas.delete(tag)
            self.map_canvas.create_image(
                c*TILESIZE, r*TILESIZE,
                image=self.tile_images[self.selected_tile],
                anchor='nw', tags=("tile", tag)
            )

    def save_map(self):
        path = fd.asksaveasfilename(
            defaultextension=".json",
            filetypes=[("JSON","*.json")]
        )
        if not path:
            return
        data = {
            "width": MAP_COLS,
            "height": MAP_ROWS,
            "tiles": self.tilemap
        }
        with open(path, "w") as f:
            json.dump(data, f, indent=2)
        print("Map saved to", path)

    def load_map(self):
        path = fd.askopenfilename(
            defaultextension=".json",
            filetypes=[("JSON","*.json")]
        )
        if not path:
            return
        with open(path) as f:
            data = json.load(f)
        self.tilemap = data.get("tiles", self.tilemap)
        self.map_canvas.delete("tile")
        for r in range(min(len(self.tilemap), MAP_ROWS)):
            for c in range(min(len(self.tilemap[r]), MAP_COLS)):
                ttype = self.tilemap[r][c]
                if ttype:
                    tag = f"tile_{r}_{c}"
                    self.map_canvas.create_image(
                        c*TILESIZE, r*TILESIZE,
                        image=self.tile_images.get(ttype),
                        anchor='nw', tags=("tile", tag)
                    )
        print("Map loaded from", path)


def main():
    root = tk.Tk()
    TileMapEditor(root)
    root.mainloop()

if __name__ == "__main__":
    main()
