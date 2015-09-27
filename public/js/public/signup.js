/**
 * Handling signup submission form
 */

var form = $('form#signup');
var sButton = form.find('button[type="submit"]');

var partySelect = form.find('select[name="party"]');
var newPartyInput = form.find('input[name="newParty"]');

var refreshParty = function() {
	var creatingNew = parseInt(partySelect.val()) === -1;
	newPartyInput.closest('.form-group')[creatingNew? 'show' : 'hide']();
	newPartyInput.prop('required', creatingNew);
};

partySelect.change(function(ev){
	refreshParty();
});

$(document).load(function(ev){
	refreshParty();
});

var sButtonText = sButton.text();
var flashSubmitError = function() {
	sButton.text('Error!');
	sButton.addClass('btn-error');
	setTimeout(function(){
		sButton.text(sButtonText);
		sButton.removeClass('btn-error');
		sButton.prop('disabled', false);
	}, 1000);
};

// Election inputs
var ei = {
	level: find.form('input[name]')
};

form.submit(function(ev){
	ev.preventDefault();
	
	var jForm = new FormData();
	jForm.append('firstName', 		form.find('input[name="firstName"]').val().trim());
	jForm.append('lastName', 		form.find('input[name="lastName"]').val().trim());
	jForm.append('profilePhoto', 	form.find('input[name="profilePhoto"]').get(0).files[0]);
	jForm.append('about', 			form.find('textarea[name="about"]').val().trim());
	jForm.append('email', 			form.find('input[name="email"]').val().trim());
	jForm.append('password',		form.find('input[name="password"]').val().trim());
	jForm.append('dob',				form.find('input[name="dob"]').val().trim());

	if(newPartyInput.is(':visible'))
		JForm.append('newParty', newPartyInput.val().trim());
	else
		jForm.append('party', parseInt(partySelect.val()));
	
	sButton.text('Submitting...');
	sButton.prop('disabled', true);
	
	$.ajax({
		type: 'POST',
		url: '/signup',
		data: jForm,
		mimType: 'multipart/form-data',
		contentType: false,
		cache: false,
		processData: false,
		success: function(res) {
			if(res.error) {
				flashSubmitError();
				alert(res.error);
			} else {
				sButton.text('Success!');
				
				alert('Success!');
			}
				
		},
		error: function() {
			flashSubmitError();
			alert('Problem connecting to server...');
		}
	});
	
});

