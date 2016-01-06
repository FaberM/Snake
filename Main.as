package 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.*;
	import flash.utils.Timer;
	import org.papervision3d.view.BasicView;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.cameras.*;
	import org.papervision3d.objects.primitives.*;
	import org.papervision3d.materials.*;
	import org.papervision3d.render.*;
	import org.papervision3d.view.*;
	import org.papervision3d.scenes.*;

	
	/**
	 * ...
	 * @author Fab
	 */
	
public class Main extends BasicView {
	
	public var score:Number = 0;
	
	public var cubeMaterialsList:MaterialsList;
	public var appleMaterialsList:MaterialsList;
	public var refMaterialsList:MaterialsList;
	public var refHeadMaterialsList:MaterialsList;
	
	public var myFirstCube:Cube;
	public var myFirstPlane1:Plane;
	public var myFirstPlane2:Plane;
	public var myFirstPlane3:Plane;
	
	public var ref1:Cube;
	public var ref2:Cube;
	public var ref3:Cube;
	public var refArray:Array = new Array();
	
	public var refHead1:Cube;
	public var refHead2:Cube;
	public var refHead3:Cube;
	
	public var myApple:Cube;
	
	public var mainTimer:Timer = new Timer(200, 0);
	public var direction:String = "";
	
	public var snakePieces:Array = new Array();
	public var snakeArray:Array = new Array(new Array(5, 5, -5));
	
	public var instruction:MovieClip;
	
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var wallTexture:MovieClip = new MovieClip();
			
			for (var i:Number = 0; i < 20; i++)
			{
					for (var j:Number = 0; j < 20; j++)
					{
						var wallSquare:MovieClip = new MovieClip();
						wallSquare.graphics.beginFill(0xcccccc,1);
						wallSquare.graphics.lineStyle(1, 0x000000, 1);
						wallSquare.graphics.lineTo(11, 0);
						wallSquare.graphics.lineTo(11, 11);
						wallSquare.graphics.lineTo(0, 11);
						wallSquare.graphics.lineTo(0, 0);
						
						wallSquare.x = j * 10;
						wallSquare.y = i * 10;
						wallTexture.addChild(wallSquare);
					}
			}
			
			cubeMaterialsList = new MaterialsList();
			var cubeMaterial:ColorMaterial = new ColorMaterial(0x000000);
			
			cubeMaterialsList.addMaterial(cubeMaterial, "back");
			cubeMaterialsList.addMaterial(cubeMaterial, "bottom");
			cubeMaterialsList.addMaterial(cubeMaterial, "front");
			cubeMaterialsList.addMaterial(cubeMaterial, "left");
			cubeMaterialsList.addMaterial(cubeMaterial, "right");
			cubeMaterialsList.addMaterial(cubeMaterial, "top");
			
			appleMaterialsList = new MaterialsList();
			var appleMaterial:ColorMaterial = new ColorMaterial(0xff0000);
			
			appleMaterialsList.addMaterial(appleMaterial, "back");
			appleMaterialsList.addMaterial(appleMaterial, "bottom");
			appleMaterialsList.addMaterial(appleMaterial, "front");
			appleMaterialsList.addMaterial(appleMaterial, "left");
			appleMaterialsList.addMaterial(appleMaterial, "right");
			appleMaterialsList.addMaterial(appleMaterial, "top");
			
			refMaterialsList = new MaterialsList();
			var refMaterial:ColorMaterial = new ColorMaterial(0xff0000,0.75);
			
			refMaterialsList.addMaterial(refMaterial, "back");
			refMaterialsList.addMaterial(refMaterial, "bottom");
			refMaterialsList.addMaterial(refMaterial, "front");
			refMaterialsList.addMaterial(refMaterial, "left");
			refMaterialsList.addMaterial(refMaterial, "right");
			refMaterialsList.addMaterial(refMaterial, "top");
			
			refHeadMaterialsList = new MaterialsList();
			var refHeadMaterial:ColorMaterial = new ColorMaterial(0x000000, 0.75);
			
			refHeadMaterialsList.addMaterial(refHeadMaterial, "back");
			refHeadMaterialsList.addMaterial(refHeadMaterial, "bottom");
			refHeadMaterialsList.addMaterial(refHeadMaterial, "front");
			refHeadMaterialsList.addMaterial(refHeadMaterial, "left");
			refHeadMaterialsList.addMaterial(refHeadMaterial, "right");
			refHeadMaterialsList.addMaterial(refHeadMaterial, "top");
			
			// create a color material for the plane
			var planeMaterial1:MovieMaterial = new MovieMaterial(wallTexture, false);
			var planeMaterial2:MovieMaterial = new MovieMaterial(wallTexture, false);
			var planeMaterial3:MovieMaterial = new MovieMaterial(wallTexture, false);
			planeMaterial1.oneSide = false;
			planeMaterial2.oneSide = false;
			planeMaterial3.oneSide = false;
			// set the properties of the sphere instance
			// set material, radius and segements
			//myFirstSphere = new Sphere(sphereMaterial, 100, 12, 12);
			// set the properties of the paper plane instance
			// set the material and the scale
			myFirstPlane1 = new Plane(planeMaterial1, 200, 200,10,10);
			myFirstPlane2 = new Plane(planeMaterial2, 200, 200,10,10);
			myFirstPlane3 = new Plane(planeMaterial3, 200, 200, 10, 10);
			
			myFirstPlane1.y = 100;
			myFirstPlane1.z = -100;
			
			myFirstPlane2.y = 100;
			myFirstPlane2.x = 100;
			
			myFirstPlane3.x = 100;
			myFirstPlane3.z = -100;
			
			myFirstPlane1.rotationY = 90;
			myFirstPlane2.rotationY = 0;
			myFirstPlane3.rotationX = 90;
			
			setup();
			
			instruction = new MovieClip();
			instruction.graphics.beginFill(0xffffff);
			instruction.graphics.lineStyle(2, 0x000000, 1);
			instruction.graphics.drawRect(0, 0, 100, 130);
			
			var instructionTxt:TextField = new TextField();
			instructionTxt.x = 5;
			instructionTxt.width = 90;
			instructionTxt.multiline = true;
			instructionTxt.autoSize = TextFieldAutoSize.CENTER;
			instructionTxt.wordWrap = true;
			instructionTxt.text = "Use the arrow keys to move up and down and sideways, ctrl to move forward and shift to more backward. Click to reset.";
			
			instruction.addChild(instructionTxt);
			
			// add the objects to the Papervision scene
			scene.addChild(myFirstPlane1);
			scene.addChild(myFirstPlane2);
			scene.addChild(myFirstPlane3);
			
			this.addChild(instruction);
			// this is an inherited method (onRenderTick) that starts an
			// enterframe event to render the scene
			
			camera.zoom = 6;
			camera.x = 250;
			camera.y = 150;
			camera.z = -250
			
			mainTimer.addEventListener(TimerEvent.TIMER, mainTimerHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyboardHandler);
			stage.addEventListener(MouseEvent.CLICK, clickHandler);
			startRendering();
		}
		
		private function mainTimerHandler(e:TimerEvent):void
		{
			var posArray:Array;
			
			if (direction == "left")
			{
				//myFirstCube.rotationY += 5;
				//camera.x -= 5;
				//camera.z += 5;
				posArray = new Array(myFirstCube.x-10, myFirstCube.y, myFirstCube.z);
			}else if (direction == "right") {
				posArray = new Array(myFirstCube.x+10, myFirstCube.y, myFirstCube.z);
			}else if (direction == "up") {
				posArray = new Array(myFirstCube.x, myFirstCube.y+10, myFirstCube.z);
			}else if (direction == "down") {
				posArray = new Array(myFirstCube.x, myFirstCube.y-10, myFirstCube.z);
			}else if (direction == "back") {
				posArray = new Array(myFirstCube.x, myFirstCube.y, myFirstCube.z+10);
			}else if (direction == "front") {
				posArray = new Array(myFirstCube.x, myFirstCube.y, myFirstCube.z-10);
			}else {
				posArray = new Array(myFirstCube.x, myFirstCube.y, myFirstCube.z);
			}
			
			snakeArray.push(posArray);
			
			if (snakePieces[0].x == myApple.x && snakePieces[0].y == myApple.y && snakePieces[0].z == myApple.z)
			{
				//win
				var snakeCube:Cube = new Cube(cubeMaterialsList, 10, 10, 10);
				snakePieces.push(snakeCube);
				scene.addChild(snakeCube);
				score = snakePieces.length - 1;
				placeApple();
			}else {
				snakeArray.splice(0, 1);
			}
			
			//if (direction != "")
			//{
				
				for (var i:Number = 0; i < snakePieces.length; i++)
				{		
					snakePieces[i].x = snakeArray[snakeArray.length-(i+1)][0];
					snakePieces[i].y = snakeArray[snakeArray.length-(i+1)][1];
					snakePieces[i].z = snakeArray[snakeArray.length - (i + 1)][2];
					
					if (snakePieces[0].x <5 || snakePieces[0].x >195 || snakePieces[0].y <5 || snakePieces[0].y >195 || snakePieces[0].z > -5 || snakePieces[0].z < -195)
							gameOver();
					
					if (i > 0)
					{
						if (snakePieces[0].x == snakePieces[i].x && snakePieces[0].y == snakePieces[i].y && snakePieces[0].z == snakePieces[i].z)
							gameOver();
					}
					
					scene.removeChild(refArray[3]);
					scene.removeChild(refArray[4]);
					scene.removeChild(refArray[5]);
					
					refArray[3] = new Cube(refHeadMaterialsList, snakePieces[0].x, 10, 10);
					refArray[3].x = snakePieces[0].x/2;
					refArray[3].z = snakePieces[0].z;
					refArray[3].y = snakePieces[0].y;
					
					refArray[4] = new Cube(refHeadMaterialsList, 10, Math.abs(snakePieces[0].z), 10);
					refArray[4].z = snakePieces[0].z/2;
					refArray[4].x = snakePieces[0].x;
					refArray[4].y = snakePieces[0].y;
					
					refArray[5] = new Cube(refHeadMaterialsList, 10, 10, snakePieces[0].y);
					refArray[5].y = snakePieces[0].y/2;
					refArray[5].z = snakePieces[0].z;
					refArray[5].x = snakePieces[0].x;
					
					scene.addChild(refArray[3]);
					scene.addChild(refArray[4]);
					scene.addChild(refArray[5]);
					
				}
			//}
		}
		
		private function keyboardHandler(e:KeyboardEvent):void
		{
			if (e.keyCode == 37)
			{
				if (direction == "right")
				{
					gameOver();
				}else {
					direction = "left";
				}
			}else if (e.keyCode == 39) {
				if (direction == "left")
				{
					gameOver();
				}else {
					direction = "right";
				}
			}else if (e.keyCode == 38) {
				if (direction == "down")
				{
					gameOver();
				}else {
					direction = "up";
				}
			}else if (e.keyCode == 40) {
				if (direction == "up")
				{
					gameOver();
				}else {
					direction = "down";
				}
			}else if (e.keyCode == 16) {
				if (direction == "front")
				{
					gameOver();
				}else {
					direction = "back";
				}
			}else if (e.keyCode == 17) {
				if (direction == "back")
				{
					gameOver();
				}else {
					direction = "front";
				}
			}
		}
		
		private function placeApple():void
		{
			myApple.x = (Math.floor(Math.random()*20)*10)+5;
			myApple.z = -((Math.floor(Math.random()*20)*10)+5);
			myApple.y = (Math.floor(Math.random() * 20) * 10) +5;
			
			scene.removeChild(refArray[0]);
			scene.removeChild(refArray[1]);
			scene.removeChild(refArray[2]);
			
			refArray[0] = new Cube(refMaterialsList, myApple.x, 10, 10);
			refArray[0].x = myApple.x/2;
			refArray[0].z = myApple.z;
			refArray[0].y = myApple.y;
			
			refArray[1] = new Cube(refMaterialsList, 10, Math.abs(myApple.z), 10);
			refArray[1].z = myApple.z/2;
			refArray[1].x = myApple.x;
			refArray[1].y = myApple.y;
			
			refArray[2] = new Cube(refMaterialsList, 10, 10, myApple.y);
			refArray[2].y = myApple.y/2;
			refArray[2].z = myApple.z;
			refArray[2].x = myApple.x;
			
			scene.addChild(refArray[0]);
			scene.addChild(refArray[1]);
			scene.addChild(refArray[2]);
		}
		
		private function setup():void
		{
			//trace(refArray);
			for (var i:Number = 0; i < refArray.length; i++)
			{
				scene.removeChild(refArray[i]);
			}
			for (var j:Number = 0; j < snakePieces.length; j++)
			{
				scene.removeChild(snakePieces[j]);
			}
			
			direction = "";
	
			snakePieces = new Array();
			snakeArray = new Array(new Array(5, 5, -5));
			
			myFirstCube = new Cube(cubeMaterialsList, 10, 10, 10);
			myApple = new Cube(appleMaterialsList, 10, 10, 10);
			ref1 = new Cube(refMaterialsList, 10, 10, 10);
			ref2 = new Cube(refMaterialsList, 10, 10, 10);
			ref3 = new Cube(refMaterialsList, 10, 10, 10);
			refHead1 = new Cube(refMaterialsList, 10, 10, 10);
			refHead2 = new Cube(refMaterialsList, 10, 10, 10);
			refHead3 = new Cube(refMaterialsList, 10, 10, 10);
			refArray = new Array(ref1, ref2, ref3, refHead1, refHead2, refHead3, myApple, myFirstCube);
			snakePieces.push(myFirstCube);

			myFirstCube.x = snakeArray[0][0];
			myFirstCube.y = snakeArray[0][1];
			myFirstCube.z = snakeArray[0][2];
			
			scene.addChild(myFirstCube);
			scene.addChild(myApple);
			scene.addChild(ref1);
			scene.addChild(ref2);
			scene.addChild(ref3);
			scene.addChild(refHead1);
			scene.addChild(refHead2);
			scene.addChild(refHead3);
			
			
			placeApple();
			mainTimer.start();
		}
		
		private function gameOver():void
		{
			mainTimer.stop();
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			mainTimer.stop();
			setup();
		}
		
	}
	
}