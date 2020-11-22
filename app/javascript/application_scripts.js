



export const standard_data_table_opts = function() {
    return {
        pageLength: 50,
        paging: false,
        searching: true,
        sorting: true,
        info: false
    };
};

//
// function ShowToaster(flash) {
//
//     for(var i = 0; i < flash.length; i++ ){
//         var msg = flash[i];
//         var type = {
//             notice: 'success',
//             alert: 'error',
//             error: 'error',
//             warning: 'warning',
//             info: 'info'
//         };
//
//         // Setting these to 0 means it stays around until clicked
//         var timeOut = "1000";
//         var extendedTimeOut = "1000";
//         var options = {
//             notice: { "timeOut": timeOut, "extendedTimeOut": extendedTimeOut },
//             alert: { "timeOut": timeOut, "extendedTimeOut": extendedTimeOut },
//             warning: { "timeOut": timeOut, "extendedTimeOut": extendedTimeOut },
//             info: { "timeOut": timeOut, "extendedTimeOut": extendedTimeOut }
//         };
//         toastr[type[msg[0]]](msg[1], '', options[msg[0]]);
//     }
// }
