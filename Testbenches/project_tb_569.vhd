-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb is
end project_tb;

architecture project_tb_arch of project_tb is
    constant CLOCK_PERIOD : time := 20 ns;
    signal tb_clk : std_logic := '0';
    signal tb_rst, tb_start, tb_done : std_logic;
    signal tb_add : std_logic_vector(15 downto 0);
    signal tb_k   : std_logic_vector(9 downto 0);

    signal tb_o_mem_addr, exc_o_mem_addr, init_o_mem_addr : std_logic_vector(15 downto 0);
    signal tb_o_mem_data, exc_o_mem_data, init_o_mem_data : std_logic_vector(7 downto 0);
    signal tb_i_mem_data : std_logic_vector(7 downto 0);
    signal tb_o_mem_we, tb_o_mem_en, exc_o_mem_we, exc_o_mem_en, init_o_mem_we, init_o_mem_en : std_logic;

    type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (OTHERS => "00000000");

constant SCENARIO_LENGTH : integer := 529;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (67,0,188,0,197,0,0,0,225,0,45,0,26,0,0,0,111,0,169,0,62,0,84,0,54,0,52,0,114,0,21,0,174,0,167,0,184,0,44,0,0,0,174,0,16,0,237,0,120,0,6,0,31,0,227,0,0,0,92,0,209,0,230,0,158,0,252,0,53,0,193,0,0,0,78,0,55,0,0,0,136,0,0,0,235,0,0,0,23,0,225,0,190,0,0,0,221,0,0,0,227,0,249,0,156,0,192,0,79,0,0,0,103,0,227,0,13,0,75,0,128,0,129,0,135,0,0,0,0,0,252,0,22,0,172,0,233,0,0,0,0,0,0,0,0,0,0,0,35,0,213,0,169,0,146,0,8,0,199,0,137,0,244,0,53,0,244,0,115,0,31,0,251,0,75,0,248,0,0,0,235,0,179,0,190,0,0,0,253,0,0,0,107,0,146,0,18,0,168,0,150,0,232,0,43,0,0,0,0,0,125,0,112,0,0,0,0,0,19,0,0,0,170,0,176,0,245,0,10,0,128,0,0,0,34,0,28,0,158,0,0,0,33,0,113,0,43,0,20,0,30,0,0,0,0,0,0,0,26,0,23,0,0,0,74,0,134,0,41,0,14,0,20,0,69,0,19,0,210,0,142,0,198,0,0,0,196,0,172,0,139,0,0,0,0,0,0,0,231,0,48,0,0,0,207,0,144,0,21,0,212,0,0,0,137,0,108,0,188,0,154,0,119,0,145,0,208,0,63,0,76,0,165,0,162,0,112,0,251,0,43,0,0,0,194,0,87,0,135,0,215,0,103,0,206,0,42,0,235,0,197,0,93,0,86,0,252,0,246,0,82,0,108,0,251,0,96,0,196,0,186,0,116,0,76,0,139,0,0,0,222,0,0,0,33,0,237,0,254,0,251,0,241,0,139,0,53,0,143,0,248,0,231,0,233,0,127,0,94,0,196,0,0,0,0,0,140,0,94,0,118,0,65,0,0,0,25,0,97,0,0,0,105,0,0,0,249,0,33,0,7,0,204,0,250,0,36,0,231,0,192,0,0,0,190,0,205,0,234,0,50,0,120,0,173,0,135,0,131,0,82,0,0,0,13,0,19,0,50,0,79,0,255,0,139,0,59,0,213,0,202,0,72,0,191,0,0,0,118,0,0,0,116,0,244,0,0,0,69,0,14,0,190,0,232,0,221,0,53,0,38,0,244,0,0,0,82,0,61,0,57,0,222,0,0,0,20,0,242,0,70,0,9,0,37,0,0,0,135,0,151,0,127,0,0,0,144,0,0,0,14,0,0,0,0,0,58,0,0,0,16,0,197,0,189,0,125,0,2,0,122,0,0,0,58,0,150,0,85,0,21,0,71,0,166,0,251,0,135,0,0,0,214,0,248,0,125,0,207,0,16,0,179,0,202,0,235,0,4,0,208,0,167,0,33,0,165,0,145,0,140,0,188,0,164,0,164,0,249,0,86,0,131,0,214,0,244,0,197,0,0,0,146,0,201,0,0,0,41,0,127,0,147,0,0,0,70,0,0,0,117,0,170,0,247,0,0,0,212,0,199,0,254,0,252,0,23,0,0,0,149,0,144,0,0,0,88,0,129,0,125,0,120,0,92,0,133,0,79,0,206,0,224,0,179,0,59,0,106,0,100,0,122,0,128,0,90,0,149,0,248,0,196,0,199,0,214,0,64,0,246,0,142,0,0,0,18,0,27,0,89,0,135,0,172,0,31,0,106,0,186,0,53,0,21,0,210,0,183,0,175,0,5,0,119,0,177,0,88,0,53,0,0,0,14,0,91,0,174,0,25,0,246,0,68,0,0,0,130,0,6,0,82,0,76,0,0,0,30,0,222,0,212,0,0,0,104,0,235,0,155,0,90,0,248,0,15,0,166,0,154,0,14,0,254,0,106,0,95,0,0,0,31,0,0,0,62,0,0,0,106,0,0,0,237,0,60,0,116,0,53,0,223,0,0,0,221,0,0,0,63,0,254,0,0,0,0,0,62,0,28,0,114,0,0,0,241,0,92,0,30,0,225,0,171,0,190,0,65,0,134,0,0,0,139,0,132,0,62,0,244,0,0,0,25,0,0,0,0,0,249,0,0,0,103,0,196,0,0,0,35,0,69,0,91,0,101,0,226,0,0,0,0,0,22,0,167,0,129,0,29,0,243,0,227,0,2,0,0,0,107,0,0,0,100,0,21,0,147,0,48,0,222,0,252,0,0,0,228,0,137,0,0,0,73,0,35,0,42,0,147,0,193,0,30,0,195,0,153,0,57,0,45,0,0,0,181,0,0,0,114,0,19,0,21,0,119,0,163,0,80,0,219,0,95,0,218,0,156,0,172,0,0,0,238,0,0,0,208,0,119,0,174,0,210,0,230,0);
signal scenario_full  : scenario_type := (67,31,188,31,197,31,197,30,225,31,45,31,26,31,26,30,111,31,169,31,62,31,84,31,54,31,52,31,114,31,21,31,174,31,167,31,184,31,44,31,44,30,174,31,16,31,237,31,120,31,6,31,31,31,227,31,227,30,92,31,209,31,230,31,158,31,252,31,53,31,193,31,193,30,78,31,55,31,55,30,136,31,136,30,235,31,235,30,23,31,225,31,190,31,190,30,221,31,221,30,227,31,249,31,156,31,192,31,79,31,79,30,103,31,227,31,13,31,75,31,128,31,129,31,135,31,135,30,135,29,252,31,22,31,172,31,233,31,233,30,233,29,233,28,233,27,233,26,35,31,213,31,169,31,146,31,8,31,199,31,137,31,244,31,53,31,244,31,115,31,31,31,251,31,75,31,248,31,248,30,235,31,179,31,190,31,190,30,253,31,253,30,107,31,146,31,18,31,168,31,150,31,232,31,43,31,43,30,43,29,125,31,112,31,112,30,112,29,19,31,19,30,170,31,176,31,245,31,10,31,128,31,128,30,34,31,28,31,158,31,158,30,33,31,113,31,43,31,20,31,30,31,30,30,30,29,30,28,26,31,23,31,23,30,74,31,134,31,41,31,14,31,20,31,69,31,19,31,210,31,142,31,198,31,198,30,196,31,172,31,139,31,139,30,139,29,139,28,231,31,48,31,48,30,207,31,144,31,21,31,212,31,212,30,137,31,108,31,188,31,154,31,119,31,145,31,208,31,63,31,76,31,165,31,162,31,112,31,251,31,43,31,43,30,194,31,87,31,135,31,215,31,103,31,206,31,42,31,235,31,197,31,93,31,86,31,252,31,246,31,82,31,108,31,251,31,96,31,196,31,186,31,116,31,76,31,139,31,139,30,222,31,222,30,33,31,237,31,254,31,251,31,241,31,139,31,53,31,143,31,248,31,231,31,233,31,127,31,94,31,196,31,196,30,196,29,140,31,94,31,118,31,65,31,65,30,25,31,97,31,97,30,105,31,105,30,249,31,33,31,7,31,204,31,250,31,36,31,231,31,192,31,192,30,190,31,205,31,234,31,50,31,120,31,173,31,135,31,131,31,82,31,82,30,13,31,19,31,50,31,79,31,255,31,139,31,59,31,213,31,202,31,72,31,191,31,191,30,118,31,118,30,116,31,244,31,244,30,69,31,14,31,190,31,232,31,221,31,53,31,38,31,244,31,244,30,82,31,61,31,57,31,222,31,222,30,20,31,242,31,70,31,9,31,37,31,37,30,135,31,151,31,127,31,127,30,144,31,144,30,14,31,14,30,14,29,58,31,58,30,16,31,197,31,189,31,125,31,2,31,122,31,122,30,58,31,150,31,85,31,21,31,71,31,166,31,251,31,135,31,135,30,214,31,248,31,125,31,207,31,16,31,179,31,202,31,235,31,4,31,208,31,167,31,33,31,165,31,145,31,140,31,188,31,164,31,164,31,249,31,86,31,131,31,214,31,244,31,197,31,197,30,146,31,201,31,201,30,41,31,127,31,147,31,147,30,70,31,70,30,117,31,170,31,247,31,247,30,212,31,199,31,254,31,252,31,23,31,23,30,149,31,144,31,144,30,88,31,129,31,125,31,120,31,92,31,133,31,79,31,206,31,224,31,179,31,59,31,106,31,100,31,122,31,128,31,90,31,149,31,248,31,196,31,199,31,214,31,64,31,246,31,142,31,142,30,18,31,27,31,89,31,135,31,172,31,31,31,106,31,186,31,53,31,21,31,210,31,183,31,175,31,5,31,119,31,177,31,88,31,53,31,53,30,14,31,91,31,174,31,25,31,246,31,68,31,68,30,130,31,6,31,82,31,76,31,76,30,30,31,222,31,212,31,212,30,104,31,235,31,155,31,90,31,248,31,15,31,166,31,154,31,14,31,254,31,106,31,95,31,95,30,31,31,31,30,62,31,62,30,106,31,106,30,237,31,60,31,116,31,53,31,223,31,223,30,221,31,221,30,63,31,254,31,254,30,254,29,62,31,28,31,114,31,114,30,241,31,92,31,30,31,225,31,171,31,190,31,65,31,134,31,134,30,139,31,132,31,62,31,244,31,244,30,25,31,25,30,25,29,249,31,249,30,103,31,196,31,196,30,35,31,69,31,91,31,101,31,226,31,226,30,226,29,22,31,167,31,129,31,29,31,243,31,227,31,2,31,2,30,107,31,107,30,100,31,21,31,147,31,48,31,222,31,252,31,252,30,228,31,137,31,137,30,73,31,35,31,42,31,147,31,193,31,30,31,195,31,153,31,57,31,45,31,45,30,181,31,181,30,114,31,19,31,21,31,119,31,163,31,80,31,219,31,95,31,218,31,156,31,172,31,172,30,238,31,238,30,208,31,119,31,174,31,210,31,230,31);

    signal memory_control : std_logic := '0';
    
    constant SCENARIO_ADDRESS : integer := 1234;

    component project_reti_logiche is
        port (
                i_clk : in std_logic;
                i_rst : in std_logic;
                i_start : in std_logic;
                i_add : in std_logic_vector(15 downto 0);
                i_k   : in std_logic_vector(9 downto 0);
                
                o_done : out std_logic;
                
                o_mem_addr : out std_logic_vector(15 downto 0);
                i_mem_data : in  std_logic_vector(7 downto 0);
                o_mem_data : out std_logic_vector(7 downto 0);
                o_mem_we   : out std_logic;
                o_mem_en   : out std_logic
        );
    end component project_reti_logiche;

begin
    UUT : project_reti_logiche
    port map(
                i_clk   => tb_clk,
                i_rst   => tb_rst,
                i_start => tb_start,
                i_add   => tb_add,
                i_k     => tb_k,
                
                o_done => tb_done,
                
                o_mem_addr => exc_o_mem_addr,
                i_mem_data => tb_i_mem_data,
                o_mem_data => exc_o_mem_data,
                o_mem_we   => exc_o_mem_we,
                o_mem_en   => exc_o_mem_en
    );

    -- Clock generation
    tb_clk <= not tb_clk after CLOCK_PERIOD/2;

    -- Process related to the memory
    MEM : process (tb_clk)
    begin
        if tb_clk'event and tb_clk = '1' then
            if tb_o_mem_en = '1' then
                if tb_o_mem_we = '1' then
                    RAM(to_integer(unsigned(tb_o_mem_addr))) <= tb_o_mem_data after 1 ns;
                    tb_i_mem_data <= tb_o_mem_data after 1 ns;
                else
                    tb_i_mem_data <= RAM(to_integer(unsigned(tb_o_mem_addr))) after 1 ns;
                end if;
            end if;
        end if;
    end process;
    
    memory_signal_swapper : process(memory_control, init_o_mem_addr, init_o_mem_data,
                                    init_o_mem_en,  init_o_mem_we,   exc_o_mem_addr,
                                    exc_o_mem_data, exc_o_mem_en, exc_o_mem_we)
    begin
        -- This is necessary for the testbench to work: we swap the memory
        -- signals from the component to the testbench when needed.
    
        tb_o_mem_addr <= init_o_mem_addr;
        tb_o_mem_data <= init_o_mem_data;
        tb_o_mem_en   <= init_o_mem_en;
        tb_o_mem_we   <= init_o_mem_we;

        if memory_control = '1' then
            tb_o_mem_addr <= exc_o_mem_addr;
            tb_o_mem_data <= exc_o_mem_data;
            tb_o_mem_en   <= exc_o_mem_en;
            tb_o_mem_we   <= exc_o_mem_we;
        end if;
    end process;
    
    -- This process provides the correct scenario on the signal controlled by the TB
    create_scenario : process
    begin
        wait for 50 ns;

        -- Signal initialization and reset of the component
        tb_start <= '0';
        tb_add <= (others=>'0');
        tb_k   <= (others=>'0');
        tb_rst <= '1';
        
        -- Wait some time for the component to reset...
        wait for 50 ns;
        
        tb_rst <= '0';
        memory_control <= '0';  -- Memory controlled by the testbench
        
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock

        -- Configure the memory        
        for i in 0 to SCENARIO_LENGTH*2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
        
        wait until falling_edge(tb_clk);

        memory_control <= '1';  -- Memory controlled by the component
        
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS, 16));
        tb_k   <= std_logic_vector(to_unsigned(SCENARIO_LENGTH, 10));
        
        tb_start <= '1';

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        wait for 5 ns;
        
        tb_start <= '0';
        
        wait;
        
    end process;

    -- Process without sensitivity list designed to test the actual component.
    test_routine : process
    begin

        wait until tb_rst = '1';
        wait for 25 ns;
        assert tb_done = '0' report "TEST FALLITO o_done !=0 during reset" severity failure;
        wait until tb_rst = '0';

        wait until falling_edge(tb_clk);
        assert tb_done = '0' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        
        wait until rising_edge(tb_start);

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        assert tb_o_mem_en = '0' or tb_o_mem_we = '0' report "TEST FALLITO o_mem_en !=0 memory should not be written after done." severity failure;

        for i in 0 to SCENARIO_LENGTH*2-1 loop
            assert RAM(SCENARIO_ADDRESS+i) = std_logic_vector(to_unsigned(scenario_full(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(i) & " expected= " & integer'image(scenario_full(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(i)))) severity failure;
        end loop;

        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        wait until falling_edge(tb_done);

        assert false report "Simulation Ended! TEST PASSATO (EXAMPLE)" severity failure;
    end process;

end architecture;
