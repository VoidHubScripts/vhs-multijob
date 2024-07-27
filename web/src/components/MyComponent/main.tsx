import { Box, Center, Text, Stack } from "@mantine/core";
import React, { useState, useEffect } from "react";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import { fetchNui } from "../../utils/fetchNui";
import { ContextMenu } from "./ContextMenu/ContextMenu";

interface Job {
  name: string;
  grade: number;
  label: string;
}

export default function MyComponent() {
  const [opened, setOpened] = useState(false);
  const [jobs, setJobs] = useState<Job[]>([]);

  useNuiEvent<Job[]>("UPDATE_STATS", (module, data) => {
    // console.log("Received data:", JSON.stringify(data, null, 2)); 
    
    // Directly set jobs if the data is an array of Job objects
    if (Array.isArray(data)) {
      // console.log("Jobs data to be set:", data); // Log the jobs data
      setJobs(data);
    } else {
      // console.error("Invalid data structure:", JSON.stringify(data, null, 2)); // Log invalid structure
    }
  });

  useNuiEvent("OPEN", () => {
    //console.log("Opening UI");
    setOpened(true);
  });

  useNuiEvent("CLOSE", () => {
    //console.log("Closing UI");
    setOpened(false);
  });

  useEffect(() => {
    const handleKeyDown = (event: KeyboardEvent) => {
      if (event.key === "Escape") {
        if (opened) {
          setOpened(false);
          fetchNui("LOSE_FOCUS", {});
        }
      }
    };
    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, [opened]);

  return (
    <>
      {opened && (
        <>
          <Box
            w="250px"
            h="fit-content"
            p="sm"
            style={{
              background: "linear-gradient(to bottom left, rgba(0, 0, 0, 0.9), rgba(36, 85, 107, 0.9))",
              borderRadius: "var(--mantine-radius-md)",
              display: "flex",
              flexDirection: "column",
              alignItems: "center",
              opacity: 0.9,
              position: "absolute",
              right: "5%",
              top: "85%",
              transform: "translateY(-50%)",
              boxShadow: "0 4px 8px rgba(0, 0, 0, 0.3)",
              border: "1px solid rgba(255, 255, 255, 0.2)",
            }}
          >
            <Text
              ta="center"
              fw={700}
              size="xl"
              variant="gradient"
              gradient={{ from: 'blue', to: '#fa5252', deg: 131 }}
              style={{
                WebkitBackgroundClip: "text",
                WebkitTextFillColor: "transparent",
                marginBottom: "1px",
              }}
            >
              MultiJobs
            </Text>
            <ContextMenu jobs={jobs} />
          </Box>
  
          <Box
            style={{
              position: 'fixed',
              bottom: '15%',
              left: '50%',
              transform: 'translateX(-50%)',
              display: 'flex',
              justifyContent: 'center',
              width: '100%',
            }}
          >
          </Box>
        </>
      )}
    </>
  );
}