const searchForm = document.getElementById('search-form');
const cityInput = document.getElementById('city-input');

const locationLabel = document.getElementById('location-label');
const currentTemp = document.getElementById('current-temp');
const conditionText = document.getElementById('condition-text');
const conditionIcon = document.getElementById('condition-icon');
const feelsLike = document.getElementById('feels-like');
const humidity = document.getElementById('humidity');
const wind = document.getElementById('wind');
const updatedTime = document.getElementById('updated-time');
const hourlyForecast = document.getElementById('hourly-forecast');
const dailyForecast = document.getElementById('daily-forecast');

const WEATHER_CODES = {
  0: { label: 'Clear sky', icon: '☀️' },
  1: { label: 'Mainly clear', icon: '🌤️' },
  2: { label: 'Partly cloudy', icon: '⛅' },
  3: { label: 'Overcast', icon: '☁️' },
  45: { label: 'Foggy', icon: '🌫️' },
  48: { label: 'Rime fog', icon: '🌫️' },
  51: { label: 'Light drizzle', icon: '🌦️' },
  53: { label: 'Drizzle', icon: '🌦️' },
  55: { label: 'Heavy drizzle', icon: '🌧️' },
  56: { label: 'Freezing drizzle', icon: '🌧️' },
  57: { label: 'Heavy freezing drizzle', icon: '🌧️' },
  61: { label: 'Slight rain', icon: '🌦️' },
  63: { label: 'Rain', icon: '🌧️' },
  65: { label: 'Heavy rain', icon: '🌧️' },
  66: { label: 'Freezing rain', icon: '🌧️' },
  67: { label: 'Heavy freezing rain', icon: '🌧️' },
  71: { label: 'Light snow', icon: '🌨️' },
  73: { label: 'Snow', icon: '❄️' },
  75: { label: 'Heavy snow', icon: '❄️' },
  77: { label: 'Snow grains', icon: '❄️' },
  80: { label: 'Rain showers', icon: '🌦️' },
  81: { label: 'Heavy showers', icon: '🌧️' },
  82: { label: 'Violent showers', icon: '⛈️' },
  85: { label: 'Snow showers', icon: '🌨️' },
  86: { label: 'Heavy snow showers', icon: '🌨️' },
  95: { label: 'Thunderstorm', icon: '⛈️' },
  96: { label: 'Thunderstorm with hail', icon: '⛈️' },
  99: { label: 'Heavy hail storm', icon: '⛈️' }
};

const DEFAULT_CITY = 'Hyderabad';

async function getWeatherForCity(city) {
  try {
    const geoResponse = await fetch(
      `https://geocoding-api.open-meteo.com/v1/search?name=${encodeURIComponent(city)}&count=1&language=en&format=json`
    );

    const geoData = await geoResponse.json();

    if (!geoData.results || geoData.results.length === 0) {
      throw new Error('City not found. Try a different name.');
    }

    const place = geoData.results[0];
    const latitude = place.latitude;
    const longitude = place.longitude;
    const timezone = place.timezone || 'auto';

    const forecastResponse = await fetch(
      `https://api.open-meteo.com/v1/forecast?latitude=${latitude}&longitude=${longitude}&current=temperature_2m,apparent_temperature,relative_humidity_2m,weather_code,wind_speed_10m&hourly=temperature_2m,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=${encodeURIComponent(timezone)}&forecast_days=5`
    );

    const data = await forecastResponse.json();

    if (!data.current) {
      throw new Error('Weather data is unavailable right now.');
    }

    renderWeather(place, data);
  } catch (error) {
    alert(error.message || 'Unable to fetch weather data.');
  }
}

function renderWeather(place, data) {
  const current = data.current;
  const weatherCode = current.weather_code;
  const weatherInfo = WEATHER_CODES[weatherCode] || { label: 'Unknown', icon: '🌤️' };

  const currentTime = new Date(current.time);
  const cityText = `${place.name}, ${place.country || ''}`.trim();

  locationLabel.textContent = cityText;
  currentTemp.textContent = `${Math.round(current.temperature_2m)}°C`;
  conditionText.textContent = weatherInfo.label;
  conditionIcon.textContent = weatherInfo.icon;
  feelsLike.textContent = `${Math.round(current.apparent_temperature)}°C`;
  humidity.textContent = `${Math.round(current.relative_humidity_2m)}%`;
  wind.textContent = `${Math.round(current.wind_speed_10m)} km/h`;
  updatedTime.textContent = currentTime.toLocaleTimeString([], {
    hour: '2-digit',
    minute: '2-digit'
  });

  renderHourlyForecast(data.hourly, current.time);
  renderDailyForecast(data.daily);
}

function renderHourlyForecast(hourly, currentTimeString) {
  const nowIndex = hourly.time.indexOf(currentTimeString);
  const startIndex = Math.max(0, nowIndex !== -1 ? nowIndex : 0);
  const items = hourly.time.slice(startIndex, startIndex + 6).map((time, index) => {
    const temp = hourly.temperature_2m[startIndex + index];
    const code = hourly.weather_code[startIndex + index];
    const info = WEATHER_CODES[code] || { label: 'Unknown', icon: '🌤️' };

    return `
      <div class="hour-card card">
        <div class="time">${formatHourLabel(time)}</div>
        <div class="icon">${info.icon}</div>
        <div class="temp">${Math.round(temp)}°</div>
      </div>
    `;
  });

  hourlyForecast.innerHTML = items.join('');
}

function renderDailyForecast(daily) {
  const days = daily.time.slice(0, 5).map((date, index) => {
    const code = daily.weather_code[index];
    const info = WEATHER_CODES[code] || { label: 'Unknown', icon: '🌤️' };
    const max = Math.round(daily.temperature_2m_max[index]);
    const min = Math.round(daily.temperature_2m_min[index]);

    return `
      <div class="day-card card">
        <div class="day">${formatDayLabel(date)}</div>
        <div class="icon">${info.icon}</div>
        <div class="temp">${max}° / ${min}°</div>
        <div class="range">${info.label}</div>
      </div>
    `;
  });

  dailyForecast.innerHTML = days.join('');
}

function formatHourLabel(timeString) {
  const date = new Date(timeString);
  return date.toLocaleTimeString([], { hour: 'numeric' });
}

function formatDayLabel(dateString) {
  const date = new Date(dateString);
  return date.toLocaleDateString([], { weekday: 'short' });
}

searchForm.addEventListener('submit', (event) => {
  event.preventDefault();
  const city = cityInput.value.trim();
  if (!city) {
    alert('Please enter a city name.');
    return;
  }
  getWeatherForCity(city);
});

getWeatherForCity(DEFAULT_CITY);
