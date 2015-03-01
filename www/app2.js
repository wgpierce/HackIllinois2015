var watson = require('watson-developer-cloud-alpha');
var concept_insights = watson.concept_insights({
    username: '1ac8e130-c589-4837-a447-efee6f85f67b',
    password: 'W9XVVaOuP8Rr',
    version: "v1"
});

var params = {
  user: 'wikipedia',
  graph: 'en-20120601',
    text: 'Microsoft Excel - Creating and Editing Formulas Made Easy Private video Kobe Bryant greatest games: NBA record 12 threes vs Sonics (2003) The best idol auditions around the world James Buster Douglas knocks out Mike Tyson Me Singing - Safe And Sound by Taylor Swift + Civil Wars (Hunger Games) - Christina Grimmie The Dark Knight Rises Interview - Michael Caine, Morgan Freeman (2012) Batman Movie HD Dwyane Wade Dunk on Varejao (HD) Franz Liszt - Liebestraum - Love Dream Can We Auto-Correct Humanity? Increase Concentration With Study Focus Pulsating Synth (Isochronic Tones) Maroon 5 - If I Never See Your Face Again ft. Rihanna Maroon 5 - This Love Maroon 5 - Sugar Wheel of Impressions with Kevin Spacey Kate Upton Is a Flip Cup Pro (Late Night with Jimmy Fallon) Box of Lies with Jennifer Lawrence Wheel of Musical Impressions with Christina Aguilera and that idiot boy Percy Yeung he really sucks but he actually is a cool guy I have no idea'
};

concept_insights.annotateText(params, function(err, response) {
    if (err) {
        console.log(err);
    } else {
        console.log(response);
    }
});