package glue.assets;

enum GAssetType
{
	Image;
	Json;
	Sound(group:String);
	AdobeAnimateSpritesheet(fps:Int);
}
