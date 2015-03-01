var MAIN_STRING, JSON_RETURN, SEARCH_ARRAY, VIDEO_IDS, CURRENT_VIDEO_ID;
function handleAPILoaded() {
    $("body").addClass("loading");
    MAIN_STRING = "";
    SEARCH_ARRAY = [];
    VIDEO_IDS = [];
    getWatchHistoryPlaylistID();
    setTimeout(function() {
        MAIN_STRING = MAIN_STRING.replace(/["']/g, "");
        console.log("Main stringamajig is = " + MAIN_STRING);
        if (MAIN_STRING.length < 100) {
            var apology = document.createElement('div');
            var text = document.createTextNode("Sorry!\nWe couldn't find anything for that account.\nPlease refresh the page to try again.");
            apology.appendChild(text);
            apology.setAttribute('style','background-color: rgba(255,255,255,0.1);width: 400px; position: absolute; top: 30%; left: 50%;margin-left: -200px;padding: 30px; text-align: center; font-size: 1.5em; font-weight: bold;');
            document.getElementsByTagName('body')[0].appendChild(apology);
            $("body").removeClass("loading");
        } else {
            if (MAIN_STRING.length > 750) {
                console.log("More than 750");                
                //var difference = MAIN_STRING.length - 750;
                //var random = Math.floor(Math.random() * difference);
                //MAIN_STRING = MAIN_STRING.substr(random,random + 750);
                MAIN_STRING = MAIN_STRING.substr(0,700);
            }
            $.post(
                "http://localhost:3000/",
                { key1: MAIN_STRING },
                function(data) {
                    JSON_RETURN = data;
                    if (parseJSON()) {
                        searchYoutube();
                        showVideos();
                    } else {
                        var apology = document.createElement('div');
                        var text = document.createTextNode("Sorry!\nWe couldn't find anything for that account.\nPlease refresh the page to try again.");
                        apology.appendChild(text);
                        apology.setAttribute('style','background-color: rgba(255,255,255,0.1);width: 400px; position: absolute; top: 30%; left: 50%;margin-left: -200px;padding: 30px; text-align: center; font-size: 1.5em; font-weight: bold;');
                        document.getElementsByTagName('body')[0].appendChild(apology);
                        $("body").removeClass("loading");
                    }
                }
            );
        }
    }, 2000);
}

function getWatchHistoryPlaylistID() {
    var request = gapi.client.youtube.channels.list({
        part: 'contentDetails',
        mine: true
    });
    request.execute(function(response) {
        var str = response.result.items[0].contentDetails.relatedPlaylists.likes;
        listHistory(str);
        
        str = response.result.items[0].contentDetails.relatedPlaylists.favorites;
        listHistory(str);
        
        str = response.result.items[0].contentDetails.relatedPlaylists.watchHistory;
        listHistory(str);
        
        str = response.result.items[0].contentDetails.relatedPlaylists.watchLater;
        listHistory(str);
    });
}

function listHistory(playlistId) {
    var requestOptions = {
        playlistId: playlistId,
        part: 'snippet',
        maxResults: 50
    };

    var request = gapi.client.youtube.playlistItems.list(requestOptions);

    request.execute(function(response) {
        var numResults = response.result.pageInfo.totalResults;
        for (i = 0; i < numResults; i++) {
            MAIN_STRING += response.result.items[i].snippet.title + " ";
        }
    });
}

function parseJSON() {
    var JSON_LENGTH = JSON_RETURN.length;
    console.log(JSON_LENGTH);
    if (JSON_LENGTH === 0 || typeof JSON_LENGTH == 'undefined') {
        document.getElementById('player').style.display = 'none';
        document.getElementById('nextVid').style.display = 'none';
        document.getElementById('prevVid').style.visibility = 'none';
        
        return false;
    }
    var slashIndex, searchTerm;
    for (i = 0; i < JSON_LENGTH && i < 5; i++) {
        slashIndex = JSON_RETURN[i].concept.lastIndexOf('/');
        searchTerm = JSON_RETURN[i].concept.substr(slashIndex+1);
        searchTerm = searchTerm.replace("_", " ");
        SEARCH_ARRAY[i] = searchTerm;
    }
    return true;
}

function searchYoutube() {
    for (i = 0; i < SEARCH_ARRAY.length; i++) {
        addToVideoIdArray(i);
    }
}
function addToVideoIdArray(i) {
    var request = gapi.client.youtube.search.list({
        part: 'snippet',
        q: SEARCH_ARRAY[i]
    });
    request.execute(function(response) {
        var random = Math.floor(Math.random() * 5)
        VIDEO_IDS[i] = response.result.items[random].id.videoId;
        console.log("Vid id = " + VIDEO_IDS[i]);
    });
}
function showVideos() {
    setTimeout(function() {
        $('.pre-auth').hide();    
        console.log(player);
        console.log(VIDEO_IDS[0]);
        player.loadVideoById(VIDEO_IDS[0]);
        CURRENT_VIDEO_ID = 0;
        $('.post-auth').show();
        document.getElementById('player').style.visibility = 'visible';
        document.getElementById('nextVid').style.visibility = 'visible';
        document.getElementById('prevVid').style.visibility = 'visible';
        $("body").removeClass("loading");
    }, 500)
}

function nextVid() {
    if (CURRENT_VIDEO_ID === 4) {
        player.loadVideoById(VIDEO_IDS[0]);
        CURRENT_VIDEO_ID = 0;
    } else {
        player.loadVideoById(VIDEO_IDS[++CURRENT_VIDEO_ID]);
    }
}

function prevVid() {
    if (CURRENT_VIDEO_ID ===0) {
        player.loadVideoById(VIDEO_IDS[4]);
        CURRENT_VIDEO_ID = 4;
    } else {
        player.loadVideoById(VIDEO_IDS[--CURRENT_VIDEO_ID]);
    }
}