  // ===== Enquiry form  =====
  const FORM_ID = 'enquiry-form';

  function submitEnquiry(event) {
    event.preventDefault();

    const url = '/enquiry';
    if (!validateEnquiry()) {
      return;
    }

    showSubmitting();

    const formEl = document.getElementById(FORM_ID);
    const data = new FormData(formEl);

    // Debug log of fields (optional)
    for (const pair of data.entries()) {
      console.log(pair[0], pair[1]);
    }

    const request = new XMLHttpRequest();
    request.open('POST', url, true);

    request.onload = function () {
      console.log(request.responseText);
    };

    request.onerror = function (e) {
      alert('Network error submitting your enquiry. Please try again.');
      console.error(e);
      resetSubmitting();
    };

    request.onreadystatechange = function () {
      if (request.readyState === 4) {
        if (request.status === 200) {
          console.log('Request successful:', request.responseText);
          let payload = null;
          try {
            payload = JSON.parse(request.responseText);
          } catch (_) {
            payload = null;
          }
          if (payload && payload.emailSent === false) {
            alert(
              'Your enquiry has been recorded, but the email could not be sent. '
              + 'If this is urgent, please call 0451 086 561.',
            );
          } else {
            alert('Thanks — your enquiry has been sent. I’ll call you back soon.');
          }
          closeModal(event);
        } else {
          console.error('Unexpected status:', request.status, request.responseText);
          const message = (request.responseText || '').trim();
          alert(
            message
              || ('Sorry, something went wrong submitting your enquiry.\n'
                + 'Please try again or call 0451 086 561.'),
          );
          // Keep the dialog open so the user doesn’t lose their input
          // You can reset the button here if you prefer:
          resetSubmitting();
        }
      }
    };

    request.send(data);
  }

  function showSubmitting() {
    const submit = document.getElementById('submit-button');
    const cancel = document.getElementById('cancel-button');

    if (cancel) cancel.remove();
    if (submit) {
      submit.textContent = 'Submitting...';
      submit.onclick = null;
      submit.style.pointerEvents = 'none';
      submit.style.opacity = '0.8';
    }
  }

  function resetSubmitting() {
    const submit = document.getElementById('submit-button');
    if (submit) {
      submit.textContent = 'Send enquiry';
      submit.style.pointerEvents = '';
      submit.style.opacity = '';
      submit.onclick = submitEnquiry;
    }
  }

  function validateEnquiry() {
    const formEl = document.getElementById(FORM_ID);

    const firstName = formEl.querySelector('[name="first-name"]');
    const surname = formEl.querySelector('[name="surname"]');
    const email = formEl.querySelector('[name="email"]');
    const phone = formEl.querySelector('[name="phone"]');
    const street = formEl.querySelector('[name="address-street"]');
    const suburb = formEl.querySelector('[name="address-suburb"]');
    const desc = formEl.querySelector('[name="description"]');
    const honeypot = formEl.querySelector('[name="website"]'); // should be empty

    const firstNameValue = firstName ? firstName.value.trim() : '';
    const surnameValue = surname ? surname.value.trim() : '';

    // Basic required fields
    if (!firstNameValue ||
        !surnameValue ||
        !email.value.trim() ||
        !phone.value.trim() ||
        !street.value.trim() ||
        !suburb.value.trim()) {
      alert(
        'Please enter your first name, surname, email, phone number, street, and suburb.',
      );
      return false;
    }

    // Light description check (optional but helpful)
    if (!desc.value.trim()) {
      const ok = confirm('No job description provided. Submit anyway?');
      if (!ok) return false;
    }

    // Honeypot (spam) check
    if (honeypot && honeypot.value.trim() !== '') {
      // silently fail/spam
      console.warn('Honeypot triggered');
      return false;
    }

    // Preferred dates are OPTIONAL now, so no date enforcement
    return true;
  }

  function cancelEnquiry(event) {
    closeModal(event);
  }

  // If you previously had onclick="submitEnquiry(event)", update to:
  // onclick="submitEnquiry(event)"
