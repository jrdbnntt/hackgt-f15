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
	level: 	form.find('select[name="electionLevel"]'),
	type: 	form.find('select[name="electionType"]'),
	state: 	form.find('select[name="electionState"]'),
	county: 	form.find('select[name="electionCounty"]'),
	date: 	form.find('select[name="electionDate"]')
};



var refreshCounty = function() {
	if(ei.level.val() != '0') {
		ei.county.closest('.form-group').hide();
		ei.county.prop('required', false);
		return;
	}
	
	if(!$.trim(ei.state.val())) {
		ei.county.prop('disabled', true);
		ei.county.val('');
		return;
	}
	
	var options = ei.county.find('option');
	options.prop({
		disabled: true,
		hidden: true
	});
	
	stateFull = ei.state.find('option[value="'+ei.state.val()+'"]').text().trim();
	options.filter('[data-state="'+stateFull+'"]').prop({
		disabled: false,
		hidden: false
	});
	
	ei.county.val('');
	
	ei.county.closest('.form-group').show();
	ei.county.prop({
		required: true,
		disabled: false
	});
};

var refreshState = function() {
	ei.state.val('');
	
	if(ei.level.val() === '2') {
		ei.state.closest('.form-group').hide();
		ei.state.prop('required', false);
		return;
	}
	
	ei.state.closest('.form-group').show();
	ei.state.prop('required', true);
	
	refreshCounty();
};



var originalDateOptions = ei.date.html();
var refreshDates = function() {
	var electionData = {
		typeId: ei.type.val(),
		levelId: ei.level.val(),
		state: $.trim(ei.state.val()),
		county: $.trim(ei.county.val())
	};
	
	ei.date.empty();
	ei.date.html(originalDateOptions);
	ei.date.prop('disabled', true);
	
	if(!electionData.typeId || !electionData.levelId)
		return;
	
	electionData.levelId = parseInt(electionData.levelId);
	electionData.typeId = parseInt(electionData.typeId);
	
	if(electionData.levelId <= 1 && !electionData.state) {
		return;
	}
	
	if(electionData.levelId === 0 && !electionData.county) {
		return;
	}
	
	console.log(electionData);
	
	$.ajax({
		method: 'POST',
		url: '/election/dateSearch',
		data: JSON.stringify(electionData),
		contentType: 'application/json',
		success: function(res) {
			console.log(res);
			if(res.error) {
				console.log(res.error);
				return;
			}
			
			// Update the options
			
			$.each(res.elections, function(i, eData){
				ei.data.append('<option value="'+eData.id+'">'+eData.date + ' - ' + eData.position+'</option>');
			});
			
			
			ei.date.prop('disabled', false);
			
		},
		error: function(err) {
			console.log('Problem getting dates ' + err);
		}
	});
	
};

ei.level.change(function(ev) {
	refreshState();
	refreshDates();
});
ei.state.change(function(ev) {
	refreshCounty();
	refreshDates();
});
ei.county.change(function(ev) {
	refreshDates();
});

$(document).load(function(ev) {
	refreshParty();
	// setNewBallot(false);
});


var newBallot = form.find('.newElection');


var nb = {
	numCandidates: 	newBallot.find('select[name="numCandidates"]'),
	numReferendums: 	newBallot.find('select[name="numReferendums"]'),
	candidates: 		newBallot.find('.otherCandidates'),
	referendums: 		newBallot.find('.referendums-list')
};

var tmpl = {
	candidate: nb.candidates.html(),
	referendum: nb.referendums.html()
};


var refreshCandidates = function() {
	var num = nb.numCandidates.val();
	nb.candidates.empty();
	if(!num) {
		return;
	}
	
	num = parseInt(num);
	var i = 0;
	for(i = 0; i < num; ++i) {
		nb.candidates.append($(tmpl.candidate.replace(/cINT/g,'c'+i)));
	}
};
var refreshReferendums = function() {
	var num = nb.numReferendums.val();
	nb.referendums.empty();
	if(!num) {
		return;
	}
	
	num = parseInt(num);
	var i = 0;
	for(i = 0; i < num; ++i) {
		nb.referendums.append($(tmpl.referendum.replace(/rINT/g,'r'+i)));
	}
};

nb.numCandidates.change(function(ev) {
	refreshCandidates();
});
nb.numReferendums.change(function(ev) {
	refreshReferendums();
});

var setNewBallot = function(status) {
	if(!status) {
		newBallot.hide();
		newBallot.find('input, select').prop({
			disabled: true,
			required: false
		});
		return;
	} 
	
	newBallot.find('input, select').prop({
		disabled: false,
		required: true
	});
	
	refreshCandidates();
	refreshReferendums();
	
	newBallot.show();
};


ei.date.change(function(ev) {
	if(ei.date.val() == '-1') {
		setNewBallot(true);
	} else {
		setNewBallot(false);
	}
});


form.submit(function(ev){
	ev.preventDefault();
	sButton.prop('disabled', true);
	
	// Prepare data
	var jForm = new FormData();
	jForm.append('firstName', 		form.find('input[name="firstName"]').val().trim());
	jForm.append('lastName', 		form.find('input[name="lastName"]').val().trim());
	jForm.append('profilePhoto', 	form.find('input[name="profilePhoto"]').get(0).files[0]);
	jForm.append('about', 			form.find('textarea[name="about"]').val().trim());
	jForm.append('email', 			form.find('input[name="email"]').val().trim());
	jForm.append('password',		form.find('input[name="password"]').val());
	jForm.append('dob',				form.find('input[name="dob"]').val().trim());
	

	if(newPartyInput.is(':visible'))
		JForm.append('newParty', newPartyInput.val().trim());
	else
		jForm.append('partyId', parseInt(partySelect.val()));
	
	if(newBallot.is(':visible')) {
		var electionData = {
			typeId: 			parseInt(ei.type.val()),
			levelId: 		parseInt(ei.level.val()),
			state: 			$.trim(ei.state.val()),
			county: 			$.trim(ei.county.val()),
			position: 		newBallot.find('input[name="position"]').val().trim(),
			date: 			newBallot.find('input[name="newDate"]').val(),
			candidates: 	[],
			referendums: 	[]
		};
		
		var i, len, o;
		len = parseInt(nb.numCandidates.val());
		for(i = 0; i < len; ++i) {
			electionData.candidates.push({
				firstName: 	nb.candidates.find('input[name="c'+i+'-firstName"]').val().trim(),
				lastName: 	nb.candidates.find('input[name="c'+i+'-lastName"]').val().trim()
			});
		}
		
		len = parseInt(nb.numReferendums.val());
		for(i = 0; i < len; ++i) {
			electionData.referendums.push({
				name: 			nb.referendums.find('input[name="r'+i+'-name"]').val().trim(),
				description: 	nb.referendums.find('textarea[name="r'+i+'-description"]').val().trim()
			});
		}
		
		jForm.append('electionData', 	JSON.stringify(electionData));
	} else {
		jForm.append('electionId', parseInt(ei.date.val()));
	}
	
	// Validation
	if(form.find('input[name="password"]').val() !== form.find('input[name="passwordConfirm"]').val()) {
		alert('Passwords do not match');
		flashSubmitError();
		return;
	}
	
	console.log(jForm);
	
	// Submit
	sButton.text('Submitting...');
	$.ajax({
		type: 'POST',
		url: '/signup',
		data: jForm,
		mimType: 'multipart/form-data',
		contentType: false,
		cache: false,
		processData: false,
		success: function(res) {
			console.log(res);
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

