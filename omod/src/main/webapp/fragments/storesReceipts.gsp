<div class="dashboard clear">
	<div class="info-section">
		<div class="info-header">
			<i class="icon-folder-open"></i>
			<h3 class="name">VIEW RECEIPTS</h3>
			
			<div style="margin-top: -1px">
				<i class="icon-filter" style="font-size: 26px!important; color: #5b57a6"></i>				
				<label for="rcptNames">&nbsp; Name:</label>
				<input id="rcptNames" type="text" value="" name="rcptNames" placeholder="Vaccine/Diluent" style="width: 240px">
				
				<label>&nbsp;&nbsp;From&nbsp;</label>${ui.includeFragment("uicommons", "field/datetimepicker", [formFieldName: 'rFromDate', id: 'rcptFrom', label: '', useTime: false, defaultToday: false, class: ['newdtp']])}
				<label>&nbsp;&nbsp;To&nbsp;</label  >${ui.includeFragment("uicommons", "field/datetimepicker", [formFieldName: 'rToDate',   id: 'rcptDate', label: '', useTime: false, defaultToday: false, class: ['newdtp']])}
			</div>			
		</div>
	</div>
</div>

<table id="receiptsList">
    <thead>
		<th>#</th>
		<th>DATE</th>
		<th>VACCINE/DILUENT</th>
		<th>RECEIVED</th>
		<th>VVM STAGE</th>
		<th>REMARKS</th>
		<th>ACTIONS</th>
    </thead>
	
    <tbody>
		<tr>
			<td></td>
			<td colspan="6">No Records Found</td>
		</tr>
    </tbody>
</table>