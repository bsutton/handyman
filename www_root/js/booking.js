

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

processing = function (form) {
    form.style.display = 'none';

    var processing = document.createElement('span');

    processing.appendChild(document.createTextNode('processing ...'));

    form.parentNode.insertBefore(processing, form);
}