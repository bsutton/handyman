let bookingDialogId = 'booking-form';


submitBooking = function (event) {
    event.preventDefault();
    var url = "/booking";


    if (validateForm()) {

        showSubmitting();

        var request = new XMLHttpRequest();
        request.open('POST', url, true);
        request.onload = function () { // request successful
            // we can use server response to our request now
            console.log(request.responseText);
        };

        request.onerror = function (data) {
            alert(data);
        };

        request.onreadystatechange = function () {
            if (request.readyState === 4) { // Check if the request is complete
                if (request.status === 200) {
                    // Request was successful
                    console.log('Request successful:', request.responseText);
                    alert('You booking has been submitted.')
                    closeModal(event);
                } else {
                    // Handle other HTTP status codes
                    console.error('Unexpected status code:', request.status, request.responseText);
                    alert(request.responseText)
                    closeModal(event);
                }
            }
        };



        let bookingForm = document.getElementById(bookingDialogId);
        let data = new FormData(bookingForm);

        for (var pair of data.entries()) {
            console.log(pair[0], pair[1]);
        }
        request.send(data); // create FormData from form that triggered event


    }
}

showSubmitting = function () {
    let submit = document.getElementById('submit-button');
    let cancel = document.getElementById('cancel-button');

    cancel.remove();
    submit.innerHTML = "Submitting...";
    submit.onclick = null;
}

validateForm = function () {
    let bookingForm = document.getElementsByName('booking-form')[0];
    let name = document.getElementsByName("name")[0];
    let email = document.getElementsByName("email")[0];
    let phone = document.getElementsByName("phone")[0];

    if (name.value == "" || email.value == "" || phone.value == "") {
        alert("Please enter name, email and phone number!");
        return false;
    }

    let day1 = document.getElementsByName("day1-date")[0];
    let day2 = document.getElementsByName("day2-date")[0];
    let day3 = document.getElementsByName("day3-date")[0];

    if (day1.value == "" && day2.value == "" && day3.value == "") {
        alert("Please select at least one preferred date");
        return false;
    }

    return true;
}


cancelBooking = function (event) {
    closeModal(event);
}

