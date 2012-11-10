/**
This class manages sounds and musics
*/
class SFX
{
    const root = "app://sfx/";

    var sound;

    function load()
    {
        sound = new AudioPlayer();
        sound.openFile(root + "oceanwaves.wav");
    }
}
