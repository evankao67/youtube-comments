const YOUTUBE_API_KEY = 'AIzaSyAYWLesu734_hT9VZMZw4hbXKNZzrowq3I';
const commentSection = document.getElementById('result');
const urlInput = document.getElementById('url-input');
const countDiv = document.createElement('div'); 
countDiv.style.fontWeight = 'bold';
countDiv.style.fontSize = '20px';

function fetchComments() {
    const videoId = getVideoId(urlInput.value);
    if (videoId) {
        getComments(videoId, '');
    }
}

function getVideoId(url) {
    const pattern = /^(?:https?:\/\/)?(?:www\.)?youtu(?:be\.com\/watch\?v=|\.be\/)([\w\-]+)(?:\S+)?$/;
    const match = url.match(pattern);
    if (match) {
        return match[1];
    } else {
        alert('Invalid YouTube URL.');
        return null;
    }
}

function getComments(videoId, nextPageToken) {
    const url = `https://www.googleapis.com/youtube/v3/commentThreads?part=snippet&videoId=${videoId}&maxResults=100&key=${YOUTUBE_API_KEY}&pageToken=${nextPageToken}`;
    fetch(url)
        .then(response => response.json())
        .then(data => {
            const comments = data.items.map(item => item.snippet.topLevelComment.snippet.textDisplay);
            appendComments(comments);
            const nextPage = data.nextPageToken;
            if (nextPage) {
                getComments(videoId, nextPage);
            }
        })
        .catch(error => console.error(error));
}



function appendComments(comments) {
    for (let comment of comments) {
        const commentElement = document.createElement('p');
        commentElement.innerText = comment;
        commentSection.appendChild(commentElement);
    }
    countDiv.innerText = `總共 ${comments.length} 則留言：`;
    commentSection.insertBefore(countDiv, commentSection.firstChild);
}





