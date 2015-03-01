var MAIN_STRING, JSON_RETURN;
function handleAPILoaded() {
    MAIN_STRING = "";
    getWatchHistoryPlaylistID();
    setTimeout(function() {
        $.post(
        "http://localhost:3000/",
        { key1: MAIN_STRING },
        function(data) {
            JSON_RETURN = data;
            parseJSON();
        }
    ); }, 2000);
}

function getWatchHistoryPlaylistID() {
    var request = gapi.client.youtube.channels.list({
        part: 'contentDetails',
        mine: true
    });
    request.execute(function(response) {
        var str = response.result.items[0].contentDetails.relatedPlaylists.watchHistory;
        listHistory(str);
        
        str = response.result.items[0].contentDetails.relatedPlaylists.likes;
        listHistory(str);
        
        str = response.result.items[0].contentDetails.relatedPlaylists.favorites;
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
    var slashIndex, searchTerm;
    for (i = 0; i < JSON_LENGTH && i < 5; i++) {
        slashIndex = JSON_RETURN[i].concept.lastIndexOf('/');
        searchTerm = JSON_RETURN[i].concept.substr(slashIndex+1);
        searchTerm = searchTerm.replace("_", " ");
        alert(searchTerm);
    }
    alert(JSON.stringify(JSON_RETURN,null,2));
}