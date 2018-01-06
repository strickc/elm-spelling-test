import swal from 'sweetalert2';

let myAppPorts;

function swalWithResult(obj) {
  const p = Object.assign({}, obj, { showCancelButton: true });
  p.type = p.swalType;
  delete p.swalType;
  swal(p).then((result) => {
    console.log(myAppPorts);
    if (result.value) myAppPorts.swalResultOkCancel.send(true);
  });
}

function swalSimple({title, text, swalType}) {
  swal(title, text, swalType);
}

export default {
  register(appPorts) {
    myAppPorts = appPorts;
    appPorts.swal.subscribe(swalSimple);
    appPorts.swalWithResult.subscribe(swalWithResult);
  },
};