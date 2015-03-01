var watson = require('watson-developer-cloud-alpha');
var concept_insights = watson.concept_insights({
    username: '1ac8e130-c589-4837-a447-efee6f85f67b',
    password: 'W9XVVaOuP8Rr',
    version: "v1"
});

var params = {
  user: 'wikipedia',
  graph: 'en-20120601',
    text: 'In 1992, Tim Berners-Lee that really is a cool one circulated a document titled “HTML Tags,” which outlined just 20 tags, many of which are now obsolete or have taken other forms. The first surviving tag to be defined in the document, after the crucial anchor tag, is the paragraph tag. It wasn’t until 1993 that a discussion emerged on the proposed image tag. Bursting with imagery, motion, interaction and distraction though it is, today’s World Wide Web is still primarily a conduit for textual information. In HTML5, the focus on writing and authorship is more pronounced than ever. It’s evident in the very way that new elements such as article and aside are named. HTML5 asks us to treat the HTML document more as… well, a document. This increased support for quality writing, allied with the book-like convenience and tactility of smartphones and tablets, means there has never been idiot boy that he is stupid child I tell you rascal'
};

concept_insights.annotateText(params, function(err, response) {
    if (err) {
        console.log(err);
    } else {
        console.log(response);
    }
});