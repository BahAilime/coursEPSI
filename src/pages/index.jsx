import clsx from 'clsx';
import Link from '@docusaurus/Link';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import Layout from '@theme/Layout';
import Heading from '@theme/Heading';
import Timeline from '@site/src/components/Timeline';

import Learing from '@site/static/icons/360Learning.png'
import Teams from '@site/static/icons/teams.png'
import Outlook from '@site/static/icons/outlook.png'
import Edusign from '@site/static/icons/edusign.png'

import styles from './index.module.css';
import Calendar from '@site/src/components/Agenda';

function generateWeeklySteps(numberOfWeeks = 10, studyWeeks = []) {
  const steps = [];
  const currentDate = new Date();
  const startDate = new Date(currentDate.getFullYear(), 0, 1);
  const days = Math.floor((currentDate - startDate) / (24 * 60 * 60 * 1000));
  const currentWeekNumber = Math.ceil((days + startDate.getDay() + 1) / 7);

  for (let i = 0; i < numberOfWeeks; i++) {
    const weekNumber = currentWeekNumber - 2 + i;
    const weekStart = new Date(currentDate.getFullYear(), 0, 1 + (weekNumber - 1) * 7);
    const weekEnd = new Date(weekStart);
    weekEnd.setDate(weekEnd.getDate() + 6);

    const formatDate = (date) => {
      const options = { month: 'short', day: 'numeric' };
      return date.toLocaleDateString('fr-FR', options);
    };

    const step = {
      title: `Semaine ${weekNumber} (du ${formatDate(weekStart)} au ${formatDate(weekEnd)})`,
      date: `C'est une semaine ${studyWeeks.includes(weekNumber) ? "de <code>📚 cours</code>" : "d' <code>🖥️ alternance / TRE</code>"}`,
      status: weekNumber < currentWeekNumber ? 'completed' :
              weekNumber === currentWeekNumber ? 'current' : 'pending'
    };

    steps.push(step);
  }

  return steps;
}

function HomepageHeader() {
  const {siteConfig} = useDocusaurusContext();
  return (
    <header className={clsx('hero hero--primary', styles.heroBanner)}>
      <div className="container">
        <Heading as="h1" className="hero__title">
          {siteConfig.title}
        </Heading>
        <p className="hero__subtitle">{siteConfig.tagline}</p>
        <div className={styles.buttons}>
          <Link
            className="button button--secondary button--lg"
            to="/docs">
            📚 Accès aux cours
          </Link>
        </div>
      </div>
    </header>
  );
}

function LinkButton({image, title, link}) {
  return (
    <Link
      to={link}
      target='_blank'
      className="
        w-32 h-32
        flex flex-col items-center justify-center
        rounded-lg shadow-lg hover:shadow-xl
        hover:no-underline
        ">
      <img 
        src={image} 
        alt="icon" 
        className="w-10 h-10 mb-2 rounded-sm"
      />
      <span className="text-sm">{title}</span>
    </Link>
  );
}

export default function Home() {
  return (
    <Layout
      description="Les notes de cours de B3 en DEV DATA IA à l'EPSI de Nantes de Emilia Beguin">
      <HomepageHeader />
      <div className='min-w-[400px] m-auto p-4'>
        <Heading as="h1" className='mt-9'>Liens utiles</Heading>
        <div className='flex justify-center p-8 gap-5 flex-wrap'>
          <LinkButton image={Learing} title="360Learning" link="https://reseau-cd.360learning.com" />
          <LinkButton image={Teams} title="MS Teams" link="https://teams.microsoft.com/" />
          <LinkButton image={Outlook} title="Outlook" link="https://outlook.office.com/mail/" />
          <LinkButton image={Edusign} title="Edusign" link="https://www.edusign.app/student/" />
        </div>
        <Heading as="h1" className='mt-9'>Calendrier</Heading>
        <div className='flex justify-center py-3 pb-14'>
          <Timeline steps={generateWeeklySteps(8, [39, 40, 43, 46, 49, 51, 3, 6, 9, 12, 15, 18, 20, 23, 27, 28, 37])}/>
        </div>
        <Heading as="h1" className='mt-9'>Prochain cours</Heading>
        <Calendar/>
      </div>
    </Layout>
  );
}
