package com.epologee.application {	import com.epologee.application.preloader.AbstractPreloadElement;	import com.epologee.application.preloader.PEApplication;	import com.epologee.application.preloader.PreloadElementEvent;	import com.epologee.application.preloader.indicator.SpinnerIcon;	import com.epologee.util.drawing.Draw;	import com.epologee.util.drawing.ShapeDrawings;	import flash.display.DisplayObject;	import flash.display.DisplayObjectContainer;	import flash.events.Event;	import flash.events.EventDispatcher;	import flash.filters.DropShadowFilter;	import flash.geom.Point;	import flash.utils.getQualifiedClassName;	/**	 * @author Eric-Paul Lecluse | epologee.com (c) 2009	 * 	 * This class combines all preloading logic, to be used by both the PreloaderFactory and the AppController	 */	public class AbstractPreloader extends EventDispatcher {		protected var _timeline : DisplayObjectContainer;		protected var _spinner : DisplayObject;		//		private var _elementList : Array;		private var _bar : DisplayObject;
		public function set timeline(timeline : DisplayObjectContainer) : void {			_timeline = timeline;		}		public function AbstractPreloader(inPreloaderElements : Array = null) {			_elementList = [];						if (inPreloaderElements != null) {				for each (var pe : AbstractPreloadElement in inPreloaderElements) {					addElement(pe);				}			}			// let the factory class call the start() method, after setting the timeline		}		protected function addElement(inPreloaderElement : AbstractPreloadElement) : void {			_elementList.push(inPreloaderElement);		}		/**		 * First method to override		 */		public function prepare() : void {			if (!_timeline) throw new Error("Set the timeline before calling prepare()");						_spinner = _timeline.addChild(new SpinnerIcon(0xFFFFFF, 10, 5, 2));			_spinner.x = _timeline.stage.stageWidth / 2;			_spinner.y = _timeline.stage.stageHeight / 2;						_bar = _timeline.addChild(ShapeDrawings.window(64, 6, 1, 0xFFFFFF, 1, true));			_bar.x = Math.round(_spinner.x);			_bar.y = Math.round(_spinner.y + _spinner.height);			_bar.filters = [new DropShadowFilter(4, 45, 0, 1, 4, 4)];		}		/**		 * Second method to override		 */		public function start() : void {			if (!_timeline) throw new Error("Set the timeline before calling start()");						addElement(new PEApplication(_timeline));			for each (var pe : AbstractPreloadElement in _elementList) {				pe.addEventListener(PreloadElementEvent.INITIALIZED, handleElementInitialized);				pe.addEventListener(PreloadElementEvent.PROGRESS, updateProgress);				pe.start();			}		}		/**		 * Third method to override		 */		public function finish() : void {			_spinner.parent.removeChild(_spinner);			_bar.parent.removeChild(_bar);		}		/**		 * Optional override		 */		protected function updateProgress(event : Event) : void {			if (!_bar) return;						Draw.clear(_bar);			Draw.window(_bar, 64, 6, 1, 0xFFFFFF, 1, true);			Draw.rectangle(_bar, 60 * getProgress(), 2, 0xFFFFFF, 1, new Point(-30, -1));		}		protected function checkReady() : Boolean {			for each (var pe : AbstractPreloadElement in _elementList) {				if (!pe.isInitialized()) {					return false;				}			}			dispatchEvent(new Event(Event.COMPLETE));			return true;		}		protected function getProgress() : Number {			var loadedBytes : uint = 0;			var totalBytes : uint = 0;						for each (var pe : AbstractPreloadElement in _elementList) {				loadedBytes += pe.progress * pe.weight;				totalBytes += pe.weight;			}			return loadedBytes / totalBytes;		}		private function handleElementInitialized(event : PreloadElementEvent) : void {			checkReady();		}		override public function toString() : String {			var s : String = "";			// s = "[ " + name + " ]:";			return s + getQualifiedClassName(this);		}	}}