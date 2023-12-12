let bookingDialogId = 'booking-form';

submitBooking = function (event) {
    event.preventDefault();

    let bookingForm = document.getElementsByName('booking-form')[0];
    let name = document.getElementsByName("name")[0];
    let email = document.getElementsByName("email")[0];
    let phone = document.getElementsByName("phone")[0];

    if (name.value == "" || email.value == "" || phone.value == "") {
        alert("Ensure you input a value in both fields!");
    } else {
        // perform operation with form input
        console.log(
            `This form has a username of ${name.value} and password of ${email.value}`
        );

        processing(bookingForm);
        bookingForm.submit();
        // name.value = "";
        // email.value = "";
        // phone.value = "";
    }


}


submitBooking2 = function (event) {
    event.preventDefault();
    var url = "/booking";
    var request = new XMLHttpRequest();
    request.open('POST', url, true);
    request.onload = function () { // request successful
        // we can use server response to our request now
        console.log(request.responseText);
    };

    request.onerror = function () {
        // request failed
    };

    let bookingForm = document.getElementById(bookingDialogId);
    let data = new FormData(bookingForm);

    for (var pair of data.entries()) {
        console.log(pair[0], pair[1]);
    }
    request.send(data); // create FormData from form that triggered event
    closeModal(event);
}


cancelBooking = function (event) {
    closeModal(event);
}


processing = function (form) {
    form.style.display = 'none';

    var processing = document.createElement('span');

    processing.appendChild(document.createTextNode('processing ...'));

    form.parentNode.insertBefore(processing, form);
}