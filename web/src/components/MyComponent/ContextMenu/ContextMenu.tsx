import { Box, Text, Group, Button, Stack, Flex } from '@mantine/core';
import { useState, useEffect } from 'react';
import { fetchNui } from '../../../utils/fetchNui'; 
import { FaTrashAlt } from 'react-icons/fa';

interface Job {
  name: string;
  grade: number;
  label: string;
}

interface ContextMenuProps {
  jobs: Job[];
}

export function ContextMenu({ jobs }: ContextMenuProps) {
 // console.log('Context jobs data:', JSON.stringify(jobs, null, 2)); 

  useEffect(() => {
    //console.log('Jobs data updated in ContextMenu:', jobs); 
  }, [jobs]); 

  const [active, setActive] = useState<string | null>(null);
  const [deletedJobs, setDeletedJobs] = useState<string[]>([]);

  const handleButtonClick = (jobName: string, jobGrade: number) => {
    setActive(active === jobName ? null : jobName);
   // console.log('Set job button pressed:', jobName, jobGrade); 
    fetchNui('setjob', { jobName, jobGrade });
  };

  const handleRedButtonClick = (e: React.MouseEvent, jobName: string) => {
    e.stopPropagation();
    //console.log('Red button clicked for job:', jobName); 
    setDeletedJobs((prev) => [...prev, jobName]);
    fetchNui('deleteJob', { jobName });
  };

  //console.log('Received jobs data:', jobs); 

  const items = jobs.map((job) => (
    !deletedJobs.includes(job.name) && (
      <Button
        key={job.label} 
        fullWidth
        variant={active === job.name ? 'filled' : 'light'}
        color="blue"
        onClick={() => handleButtonClick(job.name, job.grade)} 
        style={{ whiteSpace: 'normal', textAlign: 'center', position: 'relative' }}
        tabIndex={-1}
      >
        <Flex align="center" justify="space-between" style={{ width: '100%' }}>
          <Box style={{ flex: 1, textAlign: 'center', paddingRight: '2.5rem' }}>{job.label}</Box>
          <Box style={{ position: 'absolute', right: 10 }}>
            <Button
              size="xs"
              color="red"
              variant="light"
              onClick={(e) => handleRedButtonClick(e, job.name)} 
              tabIndex={-1} 
            >
              <FaTrashAlt />
            </Button>
          </Box>
        </Flex>
      </Button>
    )
  ));


  return (
    <Box
      style={{
        width: '100%',
        padding: '5px',
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
      }}
    >
      <Group mb="xs"></Group>
      <Stack gap="sm" style={{ width: '100%' }}>
        {items}
      </Stack>
    </Box>
  );
}