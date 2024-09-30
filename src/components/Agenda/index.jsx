import { useEffect, useState } from 'react';
import dayjs from "dayjs";
import "dayjs/locale/fr";
import localizedFormat from 'dayjs/plugin/localizedFormat';
import weekOfYear from 'dayjs/plugin/weekOfYear';
dayjs.locale("fr");
dayjs.extend(localizedFormat);
dayjs.extend(weekOfYear);

const groupEventsByDay = (events) => {
  return events.reduce((acc, event) => {
    const date = dayjs(event.start).format("YYYY-MM-DD");
    if (!acc[date]) {
      acc[date] = [];
    }
    acc[date].push(event);
    return acc;
  }, {});
};

const Agenda = () => {
  const [events, setEvents] = useState([]);

  const week = dayjs().week()

  useEffect(() => {
    fetch(`https://raw.githubusercontent.com/BahAilime/edtEPSI/refs/heads/main/cached/B3DEVIA-DS/week${week}.json`)
      .then(response => response.json())
      .then(data => {
        setEvents(data);
      })
      .catch(_ => {
        console.log("pas de cours cette semaine")
      });

  }, []);

  const futureEvents = events.filter(event => dayjs(event.end).isAfter(dayjs()));

  const groupedEvents = groupEventsByDay(futureEvents);

  return (
    <div className="container mx-auto p-4">
      {Object.keys(groupedEvents).map((day) => (
        <div key={day} className="mb-8 shadow-[0px_3px_23px_10px_rgba(153,153,153,0.25)] rounded-lg p-6">
          <h2 className="text-2xl font-semibold">
            {dayjs(day).format("dddd D MMMM YYYY")}
          </h2>
          {groupedEvents[day].map((event, index) => (
            <div
              key={index}
              className="p-8 m-8 rounded-lg shadow-[0px_3px_23px_10px_rgba(153,153,153,0.25)]"
            >
              <h3 className="text-xl font-bold">{event.title}</h3>
              <p className="text-gray-600">
                {dayjs(event.start).format("H:mm")} - {dayjs(event.end).format("H:mm")}
              </p>
              <p className="text-gray-600">Salle: {event.location}</p>
              <p className="text-gray-600">Intervenant: {event.instructor}</p>
              <p className="text-gray-600">Groupe: {event.group}</p>
            </div>
          ))}
        </div>
      ))}
    </div>
  );
};

export default Agenda;