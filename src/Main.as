﻿package  
{
	import cepa.utils.ToolTip;
	import fl.motion.Motion;
	import fl.transitions.easing.None;
	import fl.transitions.Tween;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import pipwerks.SCORM;
	/**
	 * ...
	 * @author Luciano
	 */
	public class Main extends MovieClip
	{
		public var movimentos:int = 0;
		public var acertos:int = 0;
		private var dragging:MovieClip;
		private var startX:Number;
		private var startY:Number;
		private var dict:Dictionary;
		private var posDict:Dictionary;
		//private var wrongAnswerSound:WrongAnswerSound = new WrongAnswerSound();
		private var tweenX:Tween;
		private var tweenY:Tween;
		private var tweenX2:Tween;
		private var tweenY2:Tween;
		private const GLOW_FILTER:GlowFilter = new GlowFilter(0x6633FF, 1, 5, 5, 2, 2);
		private var alvo:MovieClip;
		private var imagePositions:Array = new Array();
		private var dictImage:Dictionary;
		private var dictCaixa:Dictionary;
		private var thumbnailDict:Dictionary;
		private var imageDict:Dictionary;
		private var images:Array = [];
		private var lastWidth:Number;
		private var lastHeight:Number;
		private var alvosUsados:Array = new Array();
		
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			this.scrollRect = new Rectangle(0, 0, 700, 650);
			botaoReset.addEventListener(MouseEvent.CLICK, reset);
			feedbackCerto.botaoOK.addEventListener(MouseEvent.CLICK, function () { feedbackCerto.visible = false; } );
			feedbackErrado.botaoOK.addEventListener(MouseEvent.CLICK, function () { feedbackErrado.visible = false; } );
			botaoInfo.addEventListener(MouseEvent.CLICK, function () { infoScreen.visible = true; setChildIndex(infoScreen, numChildren - 1); } );
			infoScreen.addEventListener(MouseEvent.CLICK, function () { infoScreen.visible = false;} );
			stage.addEventListener(KeyboardEvent.KEY_DOWN, function (e:KeyboardEvent) { if (KeyboardEvent(e).keyCode == Keyboard.ESCAPE) infoScreen.visible = false;} );
			botaoAbout.addEventListener(MouseEvent.CLICK, function () { aboutScreen.visible = true; setChildIndex(aboutScreen, numChildren - 1); } );
			aboutScreen.addEventListener(MouseEvent.CLICK, function () { aboutScreen.visible = false; } );
			stage.addEventListener(KeyboardEvent.KEY_DOWN, function (e:KeyboardEvent) { if (KeyboardEvent(e).keyCode == Keyboard.ESCAPE) aboutScreen.visible = false;} );
			
			var ttinfo:ToolTip = new ToolTip(botaoInfo, "Informações", 12, 0.8, 100, 0.5, 0.5);
			addChild(ttinfo);
			var ttreset:ToolTip = new ToolTip(botaoReset, "Nova tentativa", 12, 0.8, 100, 0.5, 0.5);
			addChild(ttreset);
			var ttcc:ToolTip = new ToolTip(botaoAbout, "Créditos", 12, 0.8, 100, 0.5, 0.5);
			addChild(ttcc);
			
			var ttThumbnail1:ToolTip = new ToolTip(thumbnail1, "Átomo", 12, 0.8, 100, 0.5, 0.5);
			addChild(ttThumbnail1);
			var ttThumbnail2:ToolTip = new ToolTip(thumbnail2, "Molécula", 12, 0.8, 100, 0.5, 0.5);
			addChild(ttThumbnail2);
			var ttThumbnail3:ToolTip = new ToolTip(thumbnail3, "Organela", 12, 0.8, 100, 0.5, 0.5);
			addChild(ttThumbnail3);
			var ttThumbnail4:ToolTip = new ToolTip(thumbnail4, "Célula", 12, 0.8, 100, 0.5, 0.5);
			addChild(ttThumbnail4);
			var ttThumbnail5:ToolTip = new ToolTip(thumbnail5, "Tecido", 12, 0.8, 100, 0.5, 0.5);
			addChild(ttThumbnail5);
			var ttThumbnail6:ToolTip = new ToolTip(thumbnail6, "Órgão", 12, 0.8, 100, 0.5, 0.5);
			addChild(ttThumbnail6);
			var ttThumbnail7:ToolTip = new ToolTip(thumbnail7, "Sistema de órgãos", 12, 0.8, 100, 0.5, 0.5);
			addChild(ttThumbnail7);
			var ttThumbnail8:ToolTip = new ToolTip(thumbnail8, "Organismo", 12, 0.8, 100, 0.5, 0.5);
			addChild(ttThumbnail8);
			var ttThumbnail9:ToolTip = new ToolTip(thumbnail9, "População", 12, 0.8, 100, 0.5, 0.5);
			addChild(ttThumbnail9);
			var ttThumbnail10:ToolTip = new ToolTip(thumbnail10, "Comunidade", 12, 0.8, 100, 0.5, 0.5);
			addChild(ttThumbnail10);
			var ttThumbnail11:ToolTip = new ToolTip(thumbnail11, "Ecossistema", 12, 0.8, 100, 0.5, 0.5);
			addChild(ttThumbnail11);
			
			var ttImagem1:ToolTip = new ToolTip(imagem1, "Átomo", 12, 0.8, 100, 0.5, 0.5);
			addChild(ttImagem1);
			var ttImagem2:ToolTip = new ToolTip(imagem2, "Molécula", 12, 0.8, 100, 0.5, 0.5);
			addChild(ttImagem2);
			var ttImagem3:ToolTip = new ToolTip(imagem3, "Organela", 12, 0.8, 100, 0.5, 0.5);
			addChild(ttImagem3);
			var ttImagem4:ToolTip = new ToolTip(imagem4, "Célula", 12, 0.8, 100, 0.5, 0.5);
			addChild(ttImagem4);
			var ttImagem5:ToolTip = new ToolTip(imagem5, "Tecido", 12, 0.8, 100, 0.5, 0.5);
			addChild(ttImagem5);
			var ttImagem6:ToolTip = new ToolTip(imagem6, "Órgão", 12, 0.8, 100, 0.5, 0.5);
			addChild(ttImagem6);
			var ttImagem7:ToolTip = new ToolTip(imagem7, "Sistema de órgãos", 12, 0.8, 100, 0.5, 0.5);
			addChild(ttImagem7);
			var ttImagem8:ToolTip = new ToolTip(imagem8, "Organismo", 12, 0.8, 100, 0.5, 0.5);
			addChild(ttImagem8);
			var ttImagem9:ToolTip = new ToolTip(imagem9, "População", 12, 0.8, 100, 0.5, 0.5);
			addChild(ttImagem9);
			var ttImagem10:ToolTip = new ToolTip(imagem10, "Comunidade", 12, 0.8, 100, 0.5, 0.5);
			addChild(ttImagem10);
			var ttImagem11:ToolTip = new ToolTip(imagem11, "Ecossistema", 12, 0.8, 100, 0.5, 0.5);
			addChild(ttImagem11);
			
			feedbackCerto.botaoOK.buttonMode = true;
			feedbackErrado.botaoOK.buttonMode = true;
			
			infoScreen.visible = false;
			aboutScreen.visible = false;
			feedbackCerto.visible = false;
			feedbackErrado.visible = false;
			
			finaliza.alpha = 0.5;
			
			for (var i:int = 1; i <= 11; i++ ) {
				this["thumbnail" + String(i)].addEventListener(MouseEvent.MOUSE_DOWN, drag);
				this["imagem" + String(i)].addEventListener(MouseEvent.MOUSE_DOWN, drag);
				imagePositions[i] = new Point(this["thumbnail" + String(i)].x, this["thumbnail" + String(i)].y);
				images[i] = this["thumbnail" + String(i)];
			}
			
			criaDict();
			
			for (var c:int = 1; c <= 11; c++) {
				var caixa:Sprite = this["caixa" + c];
				var bounds:Rectangle = caixa.getBounds(caixa);
				var mascara:Shape = new Shape();
				mascara.graphics.beginFill(0);
				mascara.graphics.drawRect(bounds.left, bounds.top, bounds.width, bounds.height);
				mascara.graphics.endFill();
				caixa.mask = mascara;
				caixa.addChild(mascara);
			}
			
			
			initLMSConnection();
		}
		
		function criaDict() :void {
			dict = new Dictionary();
			posDict = new Dictionary();
			dict[thumbnail1] = caixa1;
			dict[thumbnail2] = caixa2;
			dict[thumbnail3] = caixa3;
			dict[thumbnail4] = caixa4;
			dict[thumbnail5] = caixa5;
			dict[thumbnail6] = caixa6;
			dict[thumbnail7] = caixa7;
			dict[thumbnail8] = caixa8;
			dict[thumbnail9] = caixa9;
			dict[thumbnail10] = caixa10;
			dict[thumbnail11] = caixa11;
			
			thumbnailDict = new Dictionary();
			thumbnailDict[thumbnail1] = imagem1;
			thumbnailDict[thumbnail2] = imagem2;
			thumbnailDict[thumbnail3] = imagem3;
			thumbnailDict[thumbnail4] = imagem4;
			thumbnailDict[thumbnail5] = imagem5;
			thumbnailDict[thumbnail6] = imagem6;
			thumbnailDict[thumbnail7] = imagem7;
			thumbnailDict[thumbnail8] = imagem8;
			thumbnailDict[thumbnail9] = imagem9;
			thumbnailDict[thumbnail10] = imagem10;
			thumbnailDict[thumbnail11] = imagem11;
			
			caixas = [caixa1, caixa2, caixa3, caixa4, caixa5, caixa6, caixa7, caixa8, caixa9, caixa10, caixa11];
			
			imageDict = new Dictionary();
			imageDict[imagem1] = thumbnail1;
			imageDict[imagem2] = thumbnail2;
			imageDict[imagem3] = thumbnail3;
			imageDict[imagem4] = thumbnail4;
			imageDict[imagem5] = thumbnail5;
			imageDict[imagem6] = thumbnail6;
			imageDict[imagem7] = thumbnail7;
			imageDict[imagem8] = thumbnail8;
			imageDict[imagem9] = thumbnail9;
			imageDict[imagem10] = thumbnail10;
			imageDict[imagem11] = thumbnail11;
			
			dictImage = new Dictionary();
			dictCaixa = new Dictionary();
			
			for each (var caixa in caixas) dictCaixa[caixa] = null;
		}
		
		private function reset(e:MouseEvent):void 
		{
			movimentos = acertos = 0;
			
			posDict = new Dictionary();
			
			feedbackCerto.visible = false;
			feedbackErrado.visible = false;
			
			finaliza.removeEventListener(MouseEvent.MOUSE_DOWN, finalizaExercicio);
			finaliza.alpha = 0.5;
			finaliza.buttonMode = false;
			
			for (var i:int = 1; i <= 11; i++) {
				this["thumbnail" + String(i)].removeEventListener(MouseEvent.MOUSE_DOWN, drag);
				this["imagem" + String(i)].removeEventListener(MouseEvent.MOUSE_DOWN, drag);
				this["thumbnail" + String(i)].addEventListener(MouseEvent.MOUSE_DOWN, drag);
				this["imagem" + String(i)].addEventListener(MouseEvent.MOUSE_DOWN, drag);
				this["thumbnail" + String(i)].visible = true;
				this["thumbnail" + String(i)].x = imagePositions[i].x;
				this["thumbnail" + String(i)].y = imagePositions[i].y;
				this["thumbnail" + String(i)].gotoAndStop(1);
				this["imagem" + String(i)].visible = false;
			}
			
			alvosUsados = new Array();
			for each (var caixa in caixas) caixa.alpha = 1;
			
			criaDict();
		}
		
		var caixa_origem:DisplayObject = null;
		
		
		
		function drag(e:MouseEvent) :void {
			var i:int = 0;
			if (tweenX != null && tweenX.isPlaying) return;
			dragging = e.target as MovieClip;
			lastWidth = dragging.width;
			lastHeight = dragging.height;
			
			trace("drag --> " + dragging.name);
			if (dragging.name.slice(0, 6) == "imagem") {
				
				dragging = imageDict[dragging];
				
				caixa_origem = dictImage[dragging];
				dragging.visible = true;
				dragging.x = mouseX;
				dragging.y = mouseY;
			}
			
			
			
			/*
			for each (var key in alvosUsados) {
				if (key == dictImage[dragging]) alvosUsados.splice(i);
				i++;
			}*/
			
			dragging.gotoAndStop(1);
			dragging.alpha = 0.5;
			setChildIndex(dragging, numChildren - 1);
			startX = dragging.x;
			startY = dragging.y;
			stage.addEventListener(MouseEvent.MOUSE_UP, drop);
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			dragging.startDrag();
			
			for each (var caixa in caixas) caixa.alpha = 1;
		}
		
		function drop(e:MouseEvent) :void {
			dragging.alpha = 1;
			dragging.gotoAndStop(2);
			stage.removeEventListener(MouseEvent.MOUSE_UP, drop);
			removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			dragging.stopDrag();
			
			var thumbnail_origem:DisplayObject = dragging;
			var caixa_destino:DisplayObject = alvo;
			var caixa_destino_preenchida:Boolean = (dictCaixa[caixa_destino] != null);
			var index:int ;
			
			// ORIGEM: nada (biblioteca)
			if (caixa_origem == null) {
				
				// PARA: nada (vai para a biblioteca)
				if (caixa_destino == null) {
					// não faço nada
				}
				// PARA: caixa
				else {
					// adicionar a caixa de destino no vetor alvosUsados
					if (alvosUsados.indexOf(caixa_destino) == -1) alvosUsados.push(caixa_destino);
				}
			}
			// ORIGEM: caixa
			else {
				// PARA: nada (vai para a abiblioteca)
				if (caixa_destino == null) {
					// remover a caixa de origem do vetor alvosUsados
					index = alvosUsados.indexOf(caixa_origem);
					if (index != -1) alvosUsados.splice(index, 1);
					
				}
				// PARA: caixa
				else {
					
					// caixa_destino CONTÉM alguma imagem
					if (caixa_destino_preenchida) {
					}
					// caixa_destino NÃO contém imagem
					else {
						index = alvosUsados.indexOf(caixa_origem);
						if (index != -1) alvosUsados.splice(index, 1);
						
						alvosUsados.push(caixa_destino);
					}
				}
			}
			
			
			
			
			
			
			
			
			// DESTINO: alguma caixa
			if (alvo != null) {
				thumbnailDict[dragging].width = alvo.width;
				thumbnailDict[dragging].height = alvo.height;
				thumbnailDict[dragging].visible = true;
				dragging.visible = false;
				
				trace(dragging.name + " --> " + (dictImage[dragging] ? dictImage[dragging].name : null));
				
				// ORIGEM: biblioteca
				if (dictCaixa[alvo] == null && dictImage[dragging] == null) {
					trace("1");
					trace("ORIGEM: biblioteca");
					movimentos++;
					thumbnailDict[dragging].x = alvo.x;
					thumbnailDict[dragging].y = alvo.y;
					//tweenX = new Tween(thumbnailDict[dragging], "x", None.easeNone, dragging.x, alvo.x, 0.2, true);
					//tweenY = new Tween(thumbnailDict[dragging], "y", None.easeNone, dragging.y, alvo.y, 0.2, true);
					dictCaixa[alvo] = dragging;
					dictImage[dragging] = alvo;
					
					
				// ORIGEM: alguma caixa
				} else {
					
					//Alguma peça no alvo
					if (dictImage[dragging] == null) {
						//vindo da parte de baixo
						var posFinalDrag:Point = new Point(alvo.x, alvo.y);
						var imageAlvo:DisplayObject = dictCaixa[alvo];
						var posImagemCaixa:Point = imagePositions[images.indexOf(imageAlvo)];
						
						//setChildIndex(imageAlvo, numChildren - 1);
						
						tweenX = new Tween(thumbnailDict[dragging], "x", None.easeNone, dragging.x, posFinalDrag.x, 0.2, true);
						tweenY = new Tween(thumbnailDict[dragging], "y", None.easeNone, dragging.y, posFinalDrag.y, 0.2, true);
						
						thumbnailDict[imageAlvo].visible = false;
						imageAlvo.visible = true;
						
						tweenX2 = new Tween(imageAlvo, "x", None.easeNone, alvo.x, posImagemCaixa.x, 0.2, true);
						tweenY2 = new Tween(imageAlvo, "y", None.easeNone, alvo.y, posImagemCaixa.y, 0.2, true);
						
						dictCaixa[alvo] = dragging;
						dictImage[dragging] = alvo;
						dictImage[imageAlvo] = null;
						
					} else {
						//vindo de alguma caixa
						if (dictCaixa[alvo] == null) {
							trace("3");
							thumbnailDict[dragging].x = alvo.x;
							thumbnailDict[dragging].y = alvo.y;
							//tweenX = new Tween(thumbnailDict[dragging], "x", None.easeNone, dragging.x, alvo.x, 0.2, true);
							//tweenY = new Tween(thumbnailDict[dragging], "y", None.easeNone, dragging.y, alvo.y, 0.2, true);
							dictCaixa[dictImage[dragging]] = null;
							dictCaixa[alvo] = dragging;
							dictImage[dragging] = alvo;
							
						} else {
							trace("4");
							var caixaDrag:DisplayObject = dictImage[dragging];
							imageAlvo = dictCaixa[alvo];
							
							//setChildIndex(imageAlvo, numChildren - 1);
							
							tweenX = new Tween(thumbnailDict[dragging], "x", None.easeNone, thumbnailDict[dragging].x, alvo.x, 0.2, true);
							tweenY = new Tween(thumbnailDict[dragging], "y", None.easeNone, thumbnailDict[dragging].y, alvo.y, 0.2, true);
							
							thumbnailDict[imageAlvo].width = lastWidth;
							thumbnailDict[imageAlvo].height = lastHeight;
							
							tweenX2 = new Tween(thumbnailDict[imageAlvo], "x", None.easeNone, thumbnailDict[imageAlvo].x, caixaDrag.x, 0.2, true);
							tweenY2 = new Tween(thumbnailDict[imageAlvo], "y", None.easeNone, thumbnailDict[imageAlvo].y, caixaDrag.y, 0.2, true);
							
							dictCaixa[caixaDrag] = imageAlvo;
							dictImage[imageAlvo] = caixaDrag;
							
							dictCaixa[alvo] = dragging;
							dictImage[dragging] = alvo;
						}
					}
					
				}
			// DESTINO: biblioteca
			} else {
				var posFinal:Point = imagePositions[images.indexOf(dragging)];
				thumbnailDict[dragging].visible = false;
				if (dictImage[dragging] != null) {
					trace("5");
					//vindo de alguma caixa
					tweenX = new Tween(dragging, "x", None.easeNone, dragging.x, posFinal.x, 0.2, true);
					tweenY = new Tween(dragging, "y", None.easeNone, dragging.y, posFinal.y, 0.2, true);
					
					finaliza.removeEventListener(MouseEvent.MOUSE_DOWN, finalizaExercicio);
					finaliza.alpha = 0.5;
					finaliza.buttonMode = false;
					movimentos--;
					
					caixaDrag = dictImage[dragging];
					dictCaixa[caixaDrag] = null;
					dictImage[dragging] = null;
				} else {
					trace("6");
					//vindo do lugar inicial
					tweenX = new Tween(dragging, "x", None.easeNone, dragging.x, posFinal.x, 0.2, true);
					tweenY = new Tween(dragging, "y", None.easeNone, dragging.y, posFinal.y, 0.2, true);
				}
			}
			
			removeFilter(null);
			
			alvo = null;
			
			if (movimentos == 11) {
				finaliza.alpha = 1;
				finaliza.buttonMode = true;
				finaliza.addEventListener(MouseEvent.MOUSE_DOWN, finalizaExercicio);
			}
				
			for each (var caixa in caixas) {
				if (alvosUsados.indexOf(caixa) != -1) caixa.alpha = 0;
				else caixa.alpha = 1;
			}
			
			caixa_origem = null;
		}
		
		private function finalizaExercicio(e:Event = null):void
		{
			acertos = 0;
			for (var i:int = 1; i <= 11; i++) if (dictCaixa[this["caixa" + String(i)]] == this["thumbnail" + String(i)]) acertos++;
			
			trace("Terminou. " + String(acertos) + " acertos.");
			
			if (acertos == 11) feedbackCerto.visible = true;
			else feedbackErrado.visible = true;
			
			setChildIndex(feedbackCerto, numChildren - 1);
			setChildIndex(feedbackErrado, numChildren - 1);
			
			if(!completed){
				score = Math.floor((100 / 11) * acertos);
				completed = true;
				commit();
			}
			
			finaliza.alpha = 0.5;
			finaliza.buttonMode = false;
		}
		
		private function onMouseMove(e:MouseEvent):void 
		{	
			var peca:MovieClip;
			//alvo = null;
			
			loopForTest: for (var i:int = 1; i <= 11; i++) {
				
				peca = this["caixa" + String(i)];
				//if (peca == dragging) continue;
				
				if (peca.hitTestPoint(dragging.x, dragging.y)) {
					if (peca.moldura.filters.length == 0) peca.moldura.filters = [GLOW_FILTER];
					//setChildIndex(peca, Math.max(0, getChildIndex(dragging) - 1));
					removeFilter(peca);
					alvo = MovieClip(peca);
					//break loopForTest;
					return;
				} else {
					peca.moldura.filters = [];
				}
			}
			
			alvo = null;
		}
		
		private function removeFilter(peca:DisplayObject):void
		{
			var pecaSemFiltro:DisplayObject;
			for (var i:int = 1; i <= 11; i++) {
				pecaSemFiltro = this["caixa" + String(i)];
				if (peca != pecaSemFiltro/* && peca is Caixa*/) (pecaSemFiltro as Caixa).moldura.filters = [];
			}
		}
		
		/*------------------------------------------------------------------------------------------------*/
		//SCORM:
		
		private const PING_INTERVAL:Number = 5 * 60 * 1000; // 5 minutos
		private var completed:Boolean;
		private var scorm:SCORM;
		private var scormExercise:int;
		private var connected:Boolean;
		private var score:Number = 0;
		private var pingTimer:Timer;
		private var mementoSerialized:String = "";
		private var caixas:Array;
		
		/**
		 * @private
		 * Inicia a conexão com o LMS.
		 */
		private function initLMSConnection () : void
		{
			completed = false;
			connected = false;
			scorm = new SCORM();
			
			pingTimer = new Timer(PING_INTERVAL);
			pingTimer.addEventListener(TimerEvent.TIMER, pingLMS);
			
			connected = scorm.connect();
			
			if (connected) {
				// Verifica se a AI já foi concluída.
				var status:String = scorm.get("cmi.completion_status");	
				//mementoSerialized = String(scorm.get("cmi.suspend_data"));
				var stringScore:String = scorm.get("cmi.score.raw");
			 
				switch(status)
				{
					// Primeiro acesso à AI
					case "not attempted":
					case "unknown":
					default:
						completed = false;
						break;
					
					// Continuando a AI...
					case "incomplete":
						completed = false;
						break;
					
					// A AI já foi completada.
					case "completed":
						completed = true;
						//setMessage("ATENÇÃO: esta Atividade Interativa já foi completada. Você pode refazê-la quantas vezes quiser, mas não valerá nota.");
						break;
				}
				
				//unmarshalObjects(mementoSerialized);
				scormExercise = 1;
				score = Number(stringScore.replace(",", "."));
				//txNota.text = score.toFixed(1).replace(".", ",");
				
				var success:Boolean = scorm.set("cmi.score.min", "0");
				if (success) success = scorm.set("cmi.score.max", "100");
				
				if (success)
				{
					scorm.save();
					pingTimer.start();
				}
				else
				{
					//trace("Falha ao enviar dados para o LMS.");
					connected = false;
				}
			}
			else
			{
				trace("Esta Atividade Interativa não está conectada a um LMS: seu aproveitamento nela NÃO será salvo.");
			}
			
			//reset();
		}
		
		/**
		 * @private
		 * Salva cmi.score.raw, cmi.location e cmi.completion_status no LMS
		 */ 
		private function commit():void
		{
			if (connected)
			{
				// Salva no LMS a nota do aluno.
				var success:Boolean = scorm.set("cmi.score.raw", score.toString());

				// Notifica o LMS que esta atividade foi concluída.
				success = scorm.set("cmi.completion_status", (completed ? "completed" : "incomplete"));

				// Salva no LMS o exercício que deve ser exibido quando a AI for acessada novamente.
				success = scorm.set("cmi.location", scormExercise.toString());
				
				// Salva no LMS a string que representa a situação atual da AI para ser recuperada posteriormente.
				//mementoSerialized = marshalObjects();
				//success = scorm.set("cmi.suspend_data", mementoSerialized.toString());

				if (success)
				{
					scorm.save();
				}
				else
				{
					pingTimer.stop();
					//setMessage("Falha na conexão com o LMS.");
					connected = false;
				}
			}
		}
		
		/**
		 * @private
		 * Mantém a conexão com LMS ativa, atualizando a variável cmi.session_time
		 */
		private function pingLMS (event:TimerEvent):void
		{
			//scorm.get("cmi.completion_status");
			commit();
		}
		
		/*private function saveStatus():void
		{
			if(ExternalInterface.available){
				//mementoSerialized = marshalObjects();
				//scorm.set("cmi.suspend_data", mementoSerialized);
			}
		}*/
	}

}