/// Run with: 'dub'
import core.stdc.stdlib;
import gameapplication;

// Entry point to program
void main()
{
    GameApplication app = GameApplication("PB&J");
    app.RunLoop();
}
