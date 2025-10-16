package glue.assets;

enum AssetType
{
	Image;
	Json;
	Sound(group:String);
	AdobeAnimateSpritesheet(fps:Int);
}
