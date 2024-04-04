import React, { useEffect, useState } from "react";

interface CountdownProps {
  targetUnixTime: number; // Target Unix timestamp (in seconds)
}

const Countdown: React.FC<CountdownProps> = ({ targetUnixTime }) => {
  const [remainingTime, setRemainingTime] = useState<number>(targetUnixTime - Math.floor(Date.now() / 1000));

  useEffect(() => {
    const intervalId = setInterval(() => {
      const currentTime = Math.floor(Date.now() / 1000);
      const newRemainingTime = targetUnixTime - currentTime;
      setRemainingTime(newRemainingTime);

      if (newRemainingTime <= 0) {
        clearInterval(intervalId);
      }
    }, 1000);

    return () => {
      clearInterval(intervalId);
    };
  }, [targetUnixTime]); // Ensure the effect runs when targetUnixTime changes

  const formatDatetime = (unixTime: number): string => {
    const date = new Date(unixTime * 1000);
    return date.toLocaleString(); // Convert Unix timestamp to local datetime string
  };

  return (
    <div>
      {remainingTime > 0 ? (
        <p>Time remaining: {formatDatetime(targetUnixTime)}</p>
      ) : (
        <p>Times up! Reached at: {formatDatetime(targetUnixTime)}</p>
      )}
    </div>
  );
};

export default Countdown;
