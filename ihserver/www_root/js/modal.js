
// Stores the currenlty open modal dialog.
// Will be null if no modal dialog is open.
let openModal = null;

// show the modal dialog.
showModal = async function (event, contentUrl) {
    event.preventDefault();
    const html = await loadHtml(contentUrl);
    openModal = document.getElementById("modal-dialog");

    let container = document.getElementById("modal-container");
    container.innerHTML = html;

    // show the dialog
    openModal.classList.remove("modal-box-closed");
    openModal.classList.add("modal-box-open");
    // obscure the main page
    let modalOverlay = document.getElementById("modal-overlay");
    modalOverlay.style.display = 'block';

    // stop the body scrolling:
    let body = document.getElementById("body");
    body.classList.add('noscroll');

    return false;
}

// When the user clicks anywhere outside of the modal, close it
closeModal = function (event) {
    event.preventDefault();
    if (openModal !== null) {
        openModal.classList.remove("modal-box-open");
        openModal.classList.add("modal-box-closed");
        openModal = null;
        // un-obscure the main page
        let modalOverlay = document.getElementById("modal-overlay");
        modalOverlay.style.display = 'none';

        // resume the body scrolling:
        let body = document.getElementById("body");
        body.classList.remove('noscroll');
    }
}

// load the contents of the modal from url
loadHtml = async function (url) {
    const response = await fetch(url /*, options */);

    if (!response.ok) {
        throw new Error(`HTTP error! Status: ${response.status}`);
    }
    const data = await response.text();
    return data;
}


// show the booking dialog
showBooking = async function (event) {
    closeModal(event);
    showModal(event, 'booking.html');
}

// show the booking dialog
showAccept = async function (event) {
    showModal(event, 'accept.html');
}