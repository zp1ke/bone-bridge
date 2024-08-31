{{flutter_js}}
{{flutter_build_config}}

const searchParams = new URLSearchParams(window.location.search);
const renderer = searchParams.get('renderer');
const userConfig = renderer ? {'renderer': renderer} : {};

const loading = document.createElement('div');
document.body.appendChild(loading);
loading.textContent = "Loading...";

_flutter.loader.load({
  config: userConfig,
  serviceWorkerSettings: {
    serviceWorkerVersion: {{flutter_service_worker_version}},
  },
  onEntrypointLoaded: async function(engineInitializer) {
    loading.textContent = "Initializing engine...";
    const appRunner = await engineInitializer.initializeEngine();
    loading.textContent = "Running app...";
    await appRunner.runApp();
  },
});