import React from 'react';
import { Circle } from 'lucide-react';
import styles from './index.module.css';
import Heading from '@theme/Heading';

const Timeline = ({ steps }) => {
  return (
    <div className={styles.timeline}>
      {steps.map((step, index) => (
        <div key={index} className={styles.step}>
          <div className={styles.iconContainer}>
            <Circle
              className={`${styles.icon} ${step.status === 'current' ? styles.current : ''} ${step.status === 'completed' ? styles.completed : ''}`}
              size={16}
            />
            {index < steps.length - 1 && <div className={styles.line} />}
          </div>
          <div className={styles.content}>
            <Heading as="h3" className={styles.title}>{step.title}</Heading>
            <p className={styles.date} dangerouslySetInnerHTML={{ __html: step.date }}></p>
          </div>
        </div>
      ))}
    </div>
  );
};

export default Timeline;