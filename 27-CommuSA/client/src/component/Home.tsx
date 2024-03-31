import React, { useEffect, useState } from 'react';
import { AccountInfo } from '@aptos-labs/wallet-adapter-core';
import { Types } from 'aptos';
import { moduleAddress, client } from "../App"
import { CheckboxChangeEvent } from "antd/es/checkbox";
import { Row, Col, Button, Spin, List, Checkbox, Input } from "antd";


interface HomeProps {
    account: AccountInfo | null;
    signAndSubmitTransaction: <T extends Types.TransactionPayload, V>(transaction: T, options?: V) => Promise<any>;
}

type Task = {
    address: string;
    completed: boolean;
    content: string;
    task_id: string;
};

const Home: React.FC<HomeProps> = ({ account, signAndSubmitTransaction }) => {

    const [tasks, setTasks] = useState<Task[]>([]);
    const [newTask, setNewTask] = useState<string>("");

    const [transactionInProgress, setTransactionInProgress] =
        useState<boolean>(false);
    const [accountHasList, setAccountHasList] = useState<boolean>(false);

    useEffect(() => {
        fetchList();
    }, [account?.address]);

    // const onClick = (e: any) => {
    //     console.log('click ', e);
    // };
    const onWriteTask = (event: React.ChangeEvent<HTMLInputElement>) => {
        const value = event.target.value;
        setNewTask(value);
    };
    const fetchList = async () => {
        if (!account) return [];
        try {
            const todoListResource = await client.getAccountResource(
                account?.address,
                `${moduleAddress}::todolist::TodoList`
            );
            setAccountHasList(true);
            // tasks table handle
            const tableHandle = (todoListResource as any).data.tasks.handle;
            // tasks table counter
            const taskCounter = (todoListResource as any).data.task_counter;

            let tasks = [];
            let counter = 1;
            while (counter <= taskCounter) {
                const tableItem = {
                    key_type: "u64",
                    value_type: `${moduleAddress}::todolist::Task`,
                    key: `${counter}`,
                };
                const task = await client.getTableItem(tableHandle, tableItem);
                tasks.push(task);
                counter++;
            }
            // set tasks in local state
            setTasks(tasks);
        } catch (e: any) {
            setAccountHasList(false);
        }
    };

    const addNewList = async () => {
        if (!account) return [];
        setTransactionInProgress(true);
        // build a transaction payload to be submited
        const payload = {
            type: "entry_function_payload",
            function: `${moduleAddress}::todolist::create_list`,
            type_arguments: [],
            arguments: [],
        };
        try {
            // sign and submit transaction to chain
            const response = await signAndSubmitTransaction(payload);
            // wait for transaction
            await client.waitForTransaction(response.hash);
            setAccountHasList(true);
        } catch (error: any) {
            setAccountHasList(false);
        } finally {
            setTransactionInProgress(false);
        }
    };

    const onTaskAdded = async () => {
        // check for connected account
        if (!account) return;
        setTransactionInProgress(true);
        // build a transaction payload to be submited
        const payload = {
            type: "entry_function_payload",
            function: `${moduleAddress}::todolist::create_task`,
            type_arguments: [],
            arguments: [newTask],
        };

        // hold the latest task.task_id from our local state
        const latestId =
            tasks.length > 0 ? parseInt(tasks[tasks.length - 1].task_id) + 1 : 1;

        // build a newTaskToPush objct into our local state
        const newTaskToPush = {
            address: account.address,
            completed: false,
            content: newTask,
            task_id: latestId + "",
        };

        try {
            // sign and submit transaction to chain
            const response = await signAndSubmitTransaction(payload);
            // wait for transaction
            await client.waitForTransaction(response.hash);

            // Create a new array based on current state:
            let newTasks = [...tasks];

            // Add item to the tasks array
            newTasks.push(newTaskToPush);
            // Set state
            setTasks(newTasks);
            // clear input text
            setNewTask("");
        } catch (error: any) {
            console.log("error", error);
        } finally {
            setTransactionInProgress(false);
        }
    };

    const onCheckboxChange = async (
        event: CheckboxChangeEvent,
        taskId: string
    ) => {
        if (!account) return;
        if (!event.target.checked) return;
        setTransactionInProgress(true);
        const payload = {
            type: "entry_function_payload",
            function: `${moduleAddress}::todolist::complete_task`,
            type_arguments: [],
            arguments: [taskId],
        };

        try {
            // sign and submit transaction to chain
            const response = await signAndSubmitTransaction(payload);
            // wait for transaction
            await client.waitForTransaction(response.hash);

            setTasks((prevState) => {
                const newState = prevState.map((obj) => {
                    // if task_id equals the checked taskId, update completed property
                    if (obj.task_id === taskId) {
                        return { ...obj, completed: true };
                    }

                    // otherwise return object as is
                    return obj;
                });

                return newState;
            });
        } catch (error: any) {
            console.log("error", error);
        } finally {
            setTransactionInProgress(false);
        }
    };
    return (
        <Col span={24} >
            <Spin spinning={transactionInProgress} style={{ width: 1256 }}>
                {!accountHasList ? (
                    <Row gutter={[0, 32]} style={{ marginTop: "2rem" }}>
                        <Col span={8} offset={8}>
                            <Button
                                disabled={!account}
                                block
                                onClick={addNewList}
                                type="primary"
                                style={{ height: "40px", backgroundColor: "#3f67ff" }}
                            >
                                Add new list
                            </Button>
                        </Col>
                    </Row>
                ) : (
                    <Col style={{ marginTop: '10px' }} >
                        <Row>
                            <Input.Group compact>
                                <Input
                                    onChange={(event) => onWriteTask(event)}
                                    style={{ width: "calc(100% - 60px)" }}
                                    placeholder="Add a Task"
                                    size="large"
                                    value={newTask}
                                />
                                <Button
                                    onClick={onTaskAdded}
                                    type="primary"
                                    style={{ height: "40px", backgroundColor: "#3f67ff" }}
                                >
                                    Add
                                </Button>
                            </Input.Group>
                        </Row>
                        <Row style={{ marginTop: '10px' }}>
                            {tasks && (
                                <List
                                    size="small"
                                    bordered
                                    dataSource={tasks}
                                    style={{ width: "100%" }}
                                    renderItem={(task: Task) => (
                                        <List.Item
                                            actions={[
                                                <div>
                                                    {task.completed ? (
                                                        <Checkbox defaultChecked={true} disabled />
                                                    ) : (
                                                        <Checkbox
                                                            onChange={(event) =>
                                                                onCheckboxChange(event, task.task_id)
                                                            }
                                                        />
                                                    )}
                                                </div>,
                                            ]}
                                        >
                                            <List.Item.Meta
                                                title={task.content}
                                                description={
                                                    <a
                                                        href={`https://explorer.aptoslabs.com/account/${task.address}/`}
                                                        target="_blank"
                                                    >{`${task.address.slice(0, 6)}...${task.address.slice(
                                                        -5
                                                    )}`}</a>
                                                }
                                            />
                                        </List.Item>
                                    )}
                                />
                            )}
                        </Row>
                    </Col>
                )}
            </Spin>
        </Col>);
}

export default Home;
