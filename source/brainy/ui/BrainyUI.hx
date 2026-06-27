package brainy.ui;

import haxe.Json;
import brainy.ui.*;

typedef BrainyUIElement = {
    var type:String;
    var id:String;
    @:optional var x:Float;
    @:optional var y:Float;
    @:optional var z:Float;
    @:optional var params:Dynamic;
    @:optional var children:Array<BrainyUIElement>;
}

typedef BrainyUIData = {
    var elements:Array<BrainyUIElement>;
}

class BrainyUI extends funkin.FunkinSpriteGroup
{
    public var elements:Map<String, Dynamic>;
    private var data:BrainyUIData;

    public function new(path:String)
    {
        super();
        data = getData('');

        for (d in data.elements)
        {
            switch (d.type.toLowerCase().trim())
            {
                
            }
        }
    }

    public static function getData(path:String):BrainyUIData
    {
        return {elements: [{
            id: "",
            type: "button"
        }]};
    }
}