var scorm = pipwerks.SCORM; // Seção SCORM
scorm.version = "2004"; // Versão da API SCORM

var aiNumber = "0141";

$(document).ready(init); // Inicia a AI.

/*
 * Inicia a Atividade Interativa (AI)
 */
function init () {
	
	query = jQuery.parseQuery();

  // Insere o filme Flash na página HTML
  // ATENÇÃO: os callbacks registrados via ExternalInterface no Main.swf levam algum tempo para ficarem disponíveis para o Javascript. Por isso não é possível chamá-los imediatamente após a inserção do filme Flash na página HTML.  
	var flashvars = {};
	flashvars.ai = "swf/AI-" + aiNumber + ".swf";
	flashvars.width = "700";
	flashvars.height = "650";
	
	var params = {};
	params.menu = "false";
	params.scale = "showall";
	//params.wmode = "gpu";

	var attributes = {};
	attributes.id = "ai";
	attributes.align = "middle";

	swfobject.embedSWF("swf/AI_Loader.swf", "ai-container", flashvars.width, flashvars.height, "11.2", "expressInstall.swf", flashvars, params, attributes);
	//swfobject.embedSWF(flashvars.ai, "ai-container", flashvars.width, flashvars.height, "11.2", "expressInstall.swf", flashvars, params, attributes);
	
}

function save2LS(str) {
	localStorage.setItem("AI-" + aiNumber + "-memento", str);
}

function getLocalStorageString() {
	var stream = localStorage.getItem("AI-" + aiNumber + "-memento");
	return stream;
}

