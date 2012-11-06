include "lib://game2d/textButton.ms"
include "lib://game2d/label.ms"
include "lib://ads/adBanner.ms"

class BannerScene : Scene
{
    function init()
    {
        super.init();

        this._back = new TextButton({text:"Back", x:System.width/2, y:System.height/10*9});
        this._back.onClick = function() {
            SFX.playClick();
            this super._goBack();
        }
        this.add(this._back);

        // add first banner
        var banner = new AdBanner({
            // iOS use iAd Android use AdMob
            provider:#auto,
            adId:"a1504f8e07e325a",
            // banner size
            size:#smartPortrait,
            // test purpose
            testing:true
        });
        banner.show(0, 10);
    }

    function _goBack()
    {
        Game.instance.quit();
    }

}
