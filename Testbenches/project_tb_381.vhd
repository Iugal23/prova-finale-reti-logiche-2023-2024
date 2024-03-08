-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_381 is
end project_tb_381;

architecture project_tb_arch_381 of project_tb_381 is
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

constant SCENARIO_LENGTH : integer := 561;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (186,0,244,0,241,0,0,0,34,0,0,0,196,0,65,0,160,0,252,0,25,0,80,0,0,0,18,0,76,0,0,0,249,0,191,0,54,0,0,0,53,0,191,0,0,0,209,0,120,0,242,0,0,0,178,0,58,0,216,0,181,0,172,0,203,0,228,0,82,0,17,0,0,0,10,0,238,0,184,0,96,0,222,0,116,0,32,0,129,0,25,0,119,0,0,0,87,0,0,0,33,0,164,0,88,0,0,0,101,0,171,0,50,0,0,0,97,0,1,0,249,0,118,0,247,0,87,0,141,0,242,0,240,0,0,0,106,0,193,0,146,0,170,0,130,0,41,0,253,0,120,0,203,0,97,0,171,0,0,0,68,0,90,0,82,0,69,0,189,0,226,0,0,0,159,0,48,0,164,0,194,0,55,0,123,0,159,0,157,0,0,0,141,0,75,0,120,0,253,0,172,0,28,0,50,0,51,0,214,0,140,0,195,0,98,0,0,0,0,0,190,0,216,0,118,0,0,0,0,0,175,0,171,0,201,0,197,0,22,0,155,0,0,0,0,0,67,0,153,0,0,0,122,0,96,0,146,0,58,0,0,0,166,0,0,0,164,0,151,0,0,0,191,0,225,0,162,0,0,0,73,0,114,0,0,0,243,0,0,0,0,0,0,0,191,0,0,0,15,0,250,0,0,0,0,0,0,0,61,0,97,0,57,0,120,0,0,0,179,0,221,0,113,0,206,0,149,0,137,0,0,0,177,0,0,0,202,0,180,0,69,0,151,0,221,0,225,0,0,0,26,0,8,0,157,0,215,0,0,0,70,0,106,0,158,0,0,0,168,0,219,0,0,0,131,0,73,0,136,0,155,0,39,0,220,0,51,0,0,0,217,0,242,0,146,0,108,0,0,0,116,0,130,0,165,0,246,0,0,0,212,0,148,0,17,0,5,0,161,0,19,0,92,0,173,0,42,0,67,0,216,0,63,0,69,0,0,0,225,0,155,0,227,0,107,0,243,0,106,0,161,0,222,0,66,0,0,0,104,0,217,0,197,0,218,0,34,0,82,0,151,0,25,0,126,0,25,0,190,0,73,0,155,0,65,0,169,0,187,0,96,0,121,0,0,0,175,0,112,0,139,0,87,0,9,0,10,0,184,0,180,0,152,0,66,0,0,0,22,0,242,0,0,0,75,0,0,0,146,0,15,0,68,0,167,0,220,0,215,0,209,0,60,0,133,0,47,0,93,0,0,0,26,0,0,0,0,0,237,0,201,0,8,0,144,0,0,0,105,0,232,0,212,0,161,0,29,0,15,0,0,0,213,0,196,0,52,0,208,0,43,0,157,0,128,0,91,0,0,0,111,0,0,0,192,0,103,0,170,0,83,0,133,0,134,0,238,0,53,0,58,0,250,0,203,0,122,0,17,0,0,0,119,0,77,0,108,0,204,0,61,0,94,0,0,0,71,0,37,0,55,0,200,0,231,0,166,0,134,0,225,0,210,0,251,0,0,0,0,0,248,0,51,0,60,0,116,0,0,0,223,0,0,0,223,0,9,0,209,0,186,0,209,0,195,0,209,0,95,0,162,0,68,0,0,0,202,0,1,0,14,0,93,0,241,0,0,0,225,0,207,0,109,0,137,0,65,0,0,0,210,0,34,0,153,0,184,0,195,0,197,0,248,0,131,0,0,0,89,0,110,0,0,0,102,0,161,0,174,0,10,0,118,0,114,0,235,0,241,0,131,0,51,0,171,0,56,0,232,0,0,0,0,0,104,0,37,0,0,0,32,0,149,0,46,0,0,0,127,0,23,0,207,0,28,0,14,0,85,0,113,0,44,0,0,0,89,0,0,0,95,0,232,0,64,0,151,0,0,0,228,0,246,0,84,0,202,0,0,0,78,0,49,0,21,0,86,0,206,0,251,0,130,0,80,0,144,0,111,0,196,0,211,0,0,0,53,0,52,0,0,0,191,0,0,0,83,0,80,0,31,0,221,0,71,0,122,0,126,0,70,0,190,0,0,0,0,0,191,0,0,0,242,0,233,0,46,0,0,0,63,0,0,0,197,0,112,0,154,0,124,0,201,0,221,0,0,0,219,0,78,0,56,0,178,0,0,0,205,0,250,0,46,0,102,0,188,0,214,0,140,0,235,0,54,0,167,0,167,0,0,0,63,0,16,0,115,0,207,0,239,0,167,0,68,0,55,0,246,0,0,0,39,0,113,0,143,0,115,0,86,0,228,0,177,0,100,0,169,0,0,0,197,0,0,0,174,0,215,0,100,0,232,0,209,0,242,0,61,0,208,0,2,0,0,0,75,0,39,0,49,0,244,0,0,0,111,0,184,0,86,0,179,0,208,0,187,0,17,0,23,0,214,0,87,0,0,0,7,0,74,0,149,0,98,0,0,0,79,0,87,0,173,0,240,0,88,0,0,0,0,0,205,0,244,0,67,0,171,0,0,0,196,0,15,0,20,0,81,0,243,0,80,0,164,0,171,0,236,0,200,0,83,0,218,0,33,0,190,0,112,0);
signal scenario_full  : scenario_type := (186,31,244,31,241,31,241,30,34,31,34,30,196,31,65,31,160,31,252,31,25,31,80,31,80,30,18,31,76,31,76,30,249,31,191,31,54,31,54,30,53,31,191,31,191,30,209,31,120,31,242,31,242,30,178,31,58,31,216,31,181,31,172,31,203,31,228,31,82,31,17,31,17,30,10,31,238,31,184,31,96,31,222,31,116,31,32,31,129,31,25,31,119,31,119,30,87,31,87,30,33,31,164,31,88,31,88,30,101,31,171,31,50,31,50,30,97,31,1,31,249,31,118,31,247,31,87,31,141,31,242,31,240,31,240,30,106,31,193,31,146,31,170,31,130,31,41,31,253,31,120,31,203,31,97,31,171,31,171,30,68,31,90,31,82,31,69,31,189,31,226,31,226,30,159,31,48,31,164,31,194,31,55,31,123,31,159,31,157,31,157,30,141,31,75,31,120,31,253,31,172,31,28,31,50,31,51,31,214,31,140,31,195,31,98,31,98,30,98,29,190,31,216,31,118,31,118,30,118,29,175,31,171,31,201,31,197,31,22,31,155,31,155,30,155,29,67,31,153,31,153,30,122,31,96,31,146,31,58,31,58,30,166,31,166,30,164,31,151,31,151,30,191,31,225,31,162,31,162,30,73,31,114,31,114,30,243,31,243,30,243,29,243,28,191,31,191,30,15,31,250,31,250,30,250,29,250,28,61,31,97,31,57,31,120,31,120,30,179,31,221,31,113,31,206,31,149,31,137,31,137,30,177,31,177,30,202,31,180,31,69,31,151,31,221,31,225,31,225,30,26,31,8,31,157,31,215,31,215,30,70,31,106,31,158,31,158,30,168,31,219,31,219,30,131,31,73,31,136,31,155,31,39,31,220,31,51,31,51,30,217,31,242,31,146,31,108,31,108,30,116,31,130,31,165,31,246,31,246,30,212,31,148,31,17,31,5,31,161,31,19,31,92,31,173,31,42,31,67,31,216,31,63,31,69,31,69,30,225,31,155,31,227,31,107,31,243,31,106,31,161,31,222,31,66,31,66,30,104,31,217,31,197,31,218,31,34,31,82,31,151,31,25,31,126,31,25,31,190,31,73,31,155,31,65,31,169,31,187,31,96,31,121,31,121,30,175,31,112,31,139,31,87,31,9,31,10,31,184,31,180,31,152,31,66,31,66,30,22,31,242,31,242,30,75,31,75,30,146,31,15,31,68,31,167,31,220,31,215,31,209,31,60,31,133,31,47,31,93,31,93,30,26,31,26,30,26,29,237,31,201,31,8,31,144,31,144,30,105,31,232,31,212,31,161,31,29,31,15,31,15,30,213,31,196,31,52,31,208,31,43,31,157,31,128,31,91,31,91,30,111,31,111,30,192,31,103,31,170,31,83,31,133,31,134,31,238,31,53,31,58,31,250,31,203,31,122,31,17,31,17,30,119,31,77,31,108,31,204,31,61,31,94,31,94,30,71,31,37,31,55,31,200,31,231,31,166,31,134,31,225,31,210,31,251,31,251,30,251,29,248,31,51,31,60,31,116,31,116,30,223,31,223,30,223,31,9,31,209,31,186,31,209,31,195,31,209,31,95,31,162,31,68,31,68,30,202,31,1,31,14,31,93,31,241,31,241,30,225,31,207,31,109,31,137,31,65,31,65,30,210,31,34,31,153,31,184,31,195,31,197,31,248,31,131,31,131,30,89,31,110,31,110,30,102,31,161,31,174,31,10,31,118,31,114,31,235,31,241,31,131,31,51,31,171,31,56,31,232,31,232,30,232,29,104,31,37,31,37,30,32,31,149,31,46,31,46,30,127,31,23,31,207,31,28,31,14,31,85,31,113,31,44,31,44,30,89,31,89,30,95,31,232,31,64,31,151,31,151,30,228,31,246,31,84,31,202,31,202,30,78,31,49,31,21,31,86,31,206,31,251,31,130,31,80,31,144,31,111,31,196,31,211,31,211,30,53,31,52,31,52,30,191,31,191,30,83,31,80,31,31,31,221,31,71,31,122,31,126,31,70,31,190,31,190,30,190,29,191,31,191,30,242,31,233,31,46,31,46,30,63,31,63,30,197,31,112,31,154,31,124,31,201,31,221,31,221,30,219,31,78,31,56,31,178,31,178,30,205,31,250,31,46,31,102,31,188,31,214,31,140,31,235,31,54,31,167,31,167,31,167,30,63,31,16,31,115,31,207,31,239,31,167,31,68,31,55,31,246,31,246,30,39,31,113,31,143,31,115,31,86,31,228,31,177,31,100,31,169,31,169,30,197,31,197,30,174,31,215,31,100,31,232,31,209,31,242,31,61,31,208,31,2,31,2,30,75,31,39,31,49,31,244,31,244,30,111,31,184,31,86,31,179,31,208,31,187,31,17,31,23,31,214,31,87,31,87,30,7,31,74,31,149,31,98,31,98,30,79,31,87,31,173,31,240,31,88,31,88,30,88,29,205,31,244,31,67,31,171,31,171,30,196,31,15,31,20,31,81,31,243,31,80,31,164,31,171,31,236,31,200,31,83,31,218,31,33,31,190,31,112,31);

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
