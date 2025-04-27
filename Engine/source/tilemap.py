import tkinter as tk
from tkinter import filedialog as fd
from PIL import Image, ImageTk, ImageDraw
import json

TILESIZE = 32
TILE_TYPES = ['ground', 'ladder', 'obstacle']

class TileMapEditor:
    def __init__(self, gui, screen_width, screen_height):
        self.gui = gui
        gui.title("2D Tile Map Editor")

        self.map_cols = screen_width // TILESIZE
        self.map_rows = screen_height // TILESIZE

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
            width=self.map_cols*TILESIZE,
            height=self.map_rows*TILESIZE,
            bg="white"
        )
        self.map_canvas.pack()
        self.draw_grid()
        self.map_canvas.bind("<Button-1>", self.map_click)
        self.map_canvas.bind("<B1-Motion>", self.map_drag)

        self.tilemap = [[None for _ in range(self.map_cols)] for _ in range(self.map_rows)]

    def create_tile_images(self):
        for t in TILE_TYPES:
            img = Image.new("RGBA", (TILESIZE, TILESIZE), (0,0,0,0))
            draw = ImageDraw.Draw(img)
            if t == 'ground':
                color = (34,139,34)
            elif t == 'ladder':
                color = (0,0,0)
            else:
                color = (139,69,19)
            draw.rectangle([0,0,TILESIZE,TILESIZE], fill=color, outline="black")
            self.tile_images[t] = ImageTk.PhotoImage(img)

    def draw_atlas(self):
        self.atlas_canvas.delete("all")
        for idx, t in enumerate(TILE_TYPES):
            img = self.tile_images[t]
            self.atlas_canvas.create_image(idx*TILESIZE, 0, image=img, anchor='nw')
            if t == self.selected_tile:
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
        for i in range(self.map_cols+1):
            x = i*TILESIZE
            self.map_canvas.create_line(x, 0, x, self.map_rows*TILESIZE, fill="gray")
        for j in range(self.map_rows+1):
            y = j*TILESIZE
            self.map_canvas.create_line(0, y, self.map_cols*TILESIZE, y, fill="gray")

    def map_click(self, event):
        self.place_tile(event)

    def map_drag(self, event):
        self.place_tile(event)

    def place_tile(self, event):
        c = event.x // TILESIZE
        r = event.y // TILESIZE
        if 0 <= c < self.map_cols and 0 <= r < self.map_rows:
            self.tilemap[r][c] = self.selected_tile
            tag = f"tile_{r}_{c}"
            self.map_canvas.delete(tag)
            self.map_canvas.create_image(
                c*TILESIZE, r*TILESIZE,
                image=self.tile_images[self.selected_tile],
                anchor='nw', tags=("tile", tag)
            )

    def save_map(self):
        path = fd.asksaveasfilename(defaultextension=".json", filetypes=[("JSON","*.json")])
        if not path:
            return
        data = {
            "width": self.map_cols,
            "height": self.map_rows,
            "tiles": self.tilemap
        }
        with open(path, "w") as f:
            json.dump(data, f, indent=2)
        print("Map saved to", path)

    def load_map(self):
        path = fd.askopenfilename(defaultextension=".json", filetypes=[("JSON","*.json")])
        if not path:
            return
        with open(path) as f:
            data = json.load(f)
        self.tilemap = data.get("tiles", self.tilemap)
        self.map_canvas.delete("tile")
        for r in range(min(len(self.tilemap), self.map_rows)):
            for c in range(min(len(self.tilemap[r]), self.map_cols)):
                t = self.tilemap[r][c]
                if t:
                    tag = f"tile_{r}_{c}"
                    self.map_canvas.create_image(
                        c*TILESIZE, r*TILESIZE,
                        image=self.tile_images.get(t),
                        anchor='nw', tags=("tile", tag)
                    )


def main():
    # specify your game screen resolution (pixels)
    SCREEN_WIDTH = 640
    SCREEN_HEIGHT = 480
    root = tk.Tk()
    TileMapEditor(root, SCREEN_WIDTH, SCREEN_HEIGHT)
    root.mainloop()

if __name__ == "__main__":
    main()
