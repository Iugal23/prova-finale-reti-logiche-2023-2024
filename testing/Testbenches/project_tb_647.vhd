-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_647 is
end project_tb_647;

architecture project_tb_arch_647 of project_tb_647 is
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

constant SCENARIO_LENGTH : integer := 556;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (28,0,117,0,233,0,69,0,57,0,0,0,3,0,171,0,0,0,216,0,247,0,227,0,160,0,78,0,0,0,0,0,54,0,215,0,140,0,156,0,53,0,214,0,116,0,173,0,251,0,119,0,0,0,168,0,194,0,98,0,0,0,189,0,198,0,156,0,0,0,233,0,151,0,254,0,134,0,27,0,199,0,231,0,112,0,213,0,54,0,56,0,205,0,43,0,0,0,105,0,226,0,180,0,63,0,125,0,172,0,226,0,139,0,245,0,215,0,202,0,160,0,185,0,0,0,32,0,160,0,90,0,223,0,22,0,0,0,172,0,46,0,86,0,140,0,161,0,203,0,32,0,0,0,54,0,121,0,182,0,32,0,46,0,70,0,243,0,58,0,0,0,205,0,235,0,109,0,0,0,0,0,121,0,0,0,253,0,207,0,0,0,35,0,176,0,150,0,234,0,0,0,64,0,0,0,163,0,0,0,0,0,95,0,97,0,0,0,0,0,189,0,209,0,18,0,147,0,0,0,133,0,176,0,89,0,207,0,246,0,107,0,39,0,84,0,22,0,0,0,189,0,0,0,136,0,248,0,74,0,100,0,54,0,246,0,43,0,122,0,0,0,193,0,182,0,119,0,0,0,101,0,0,0,244,0,0,0,222,0,225,0,146,0,99,0,0,0,0,0,56,0,90,0,188,0,0,0,56,0,32,0,10,0,0,0,68,0,0,0,21,0,200,0,216,0,22,0,89,0,110,0,20,0,117,0,0,0,189,0,140,0,13,0,128,0,250,0,45,0,147,0,143,0,26,0,0,0,230,0,0,0,44,0,110,0,0,0,236,0,92,0,146,0,71,0,16,0,229,0,23,0,0,0,164,0,15,0,0,0,218,0,236,0,33,0,128,0,84,0,22,0,0,0,0,0,0,0,6,0,95,0,105,0,48,0,82,0,137,0,182,0,0,0,60,0,183,0,113,0,0,0,253,0,0,0,182,0,127,0,173,0,58,0,222,0,38,0,0,0,84,0,34,0,210,0,203,0,90,0,203,0,128,0,173,0,72,0,55,0,0,0,227,0,0,0,249,0,0,0,104,0,30,0,73,0,151,0,164,0,37,0,177,0,199,0,186,0,231,0,39,0,0,0,241,0,0,0,253,0,220,0,166,0,220,0,0,0,64,0,168,0,0,0,240,0,77,0,0,0,253,0,27,0,231,0,0,0,0,0,0,0,0,0,65,0,69,0,111,0,213,0,172,0,22,0,209,0,143,0,84,0,138,0,166,0,120,0,0,0,0,0,136,0,177,0,172,0,77,0,116,0,68,0,153,0,136,0,128,0,66,0,69,0,243,0,223,0,6,0,17,0,189,0,106,0,36,0,0,0,169,0,174,0,0,0,128,0,181,0,136,0,20,0,24,0,136,0,0,0,233,0,22,0,140,0,212,0,65,0,142,0,0,0,0,0,206,0,0,0,76,0,158,0,83,0,155,0,182,0,87,0,190,0,225,0,123,0,116,0,171,0,71,0,0,0,4,0,181,0,85,0,57,0,0,0,145,0,213,0,79,0,200,0,209,0,193,0,11,0,0,0,9,0,67,0,254,0,10,0,148,0,124,0,161,0,238,0,0,0,243,0,86,0,122,0,0,0,245,0,214,0,83,0,112,0,44,0,68,0,208,0,167,0,0,0,68,0,0,0,214,0,130,0,56,0,250,0,223,0,0,0,26,0,191,0,233,0,51,0,255,0,68,0,178,0,190,0,213,0,50,0,10,0,134,0,69,0,233,0,44,0,96,0,93,0,0,0,101,0,54,0,180,0,12,0,159,0,81,0,158,0,0,0,45,0,31,0,67,0,149,0,170,0,0,0,248,0,134,0,25,0,34,0,119,0,67,0,164,0,69,0,202,0,127,0,146,0,179,0,167,0,198,0,173,0,217,0,205,0,14,0,0,0,240,0,234,0,231,0,172,0,91,0,83,0,7,0,24,0,0,0,254,0,249,0,0,0,2,0,19,0,109,0,151,0,244,0,6,0,248,0,0,0,1,0,186,0,56,0,100,0,139,0,98,0,248,0,195,0,187,0,230,0,255,0,43,0,144,0,14,0,255,0,52,0,0,0,0,0,233,0,116,0,34,0,33,0,46,0,216,0,186,0,72,0,61,0,0,0,0,0,196,0,15,0,18,0,158,0,54,0,82,0,57,0,169,0,49,0,7,0,104,0,99,0,229,0,1,0,93,0,0,0,86,0,2,0,14,0,0,0,136,0,96,0,59,0,126,0,18,0,132,0,12,0,16,0,137,0,215,0,125,0,35,0,213,0,118,0,98,0,249,0,195,0,0,0,93,0,186,0,168,0,0,0,0,0,0,0,215,0,0,0,49,0,159,0,0,0,174,0,0,0,67,0,97,0,117,0,61,0,186,0,221,0,198,0,12,0,50,0,0,0,193,0,149,0,88,0,191,0,123,0,0,0,73,0,92,0,89,0,218,0,92,0,0,0,66,0,125,0);
signal scenario_full  : scenario_type := (28,31,117,31,233,31,69,31,57,31,57,30,3,31,171,31,171,30,216,31,247,31,227,31,160,31,78,31,78,30,78,29,54,31,215,31,140,31,156,31,53,31,214,31,116,31,173,31,251,31,119,31,119,30,168,31,194,31,98,31,98,30,189,31,198,31,156,31,156,30,233,31,151,31,254,31,134,31,27,31,199,31,231,31,112,31,213,31,54,31,56,31,205,31,43,31,43,30,105,31,226,31,180,31,63,31,125,31,172,31,226,31,139,31,245,31,215,31,202,31,160,31,185,31,185,30,32,31,160,31,90,31,223,31,22,31,22,30,172,31,46,31,86,31,140,31,161,31,203,31,32,31,32,30,54,31,121,31,182,31,32,31,46,31,70,31,243,31,58,31,58,30,205,31,235,31,109,31,109,30,109,29,121,31,121,30,253,31,207,31,207,30,35,31,176,31,150,31,234,31,234,30,64,31,64,30,163,31,163,30,163,29,95,31,97,31,97,30,97,29,189,31,209,31,18,31,147,31,147,30,133,31,176,31,89,31,207,31,246,31,107,31,39,31,84,31,22,31,22,30,189,31,189,30,136,31,248,31,74,31,100,31,54,31,246,31,43,31,122,31,122,30,193,31,182,31,119,31,119,30,101,31,101,30,244,31,244,30,222,31,225,31,146,31,99,31,99,30,99,29,56,31,90,31,188,31,188,30,56,31,32,31,10,31,10,30,68,31,68,30,21,31,200,31,216,31,22,31,89,31,110,31,20,31,117,31,117,30,189,31,140,31,13,31,128,31,250,31,45,31,147,31,143,31,26,31,26,30,230,31,230,30,44,31,110,31,110,30,236,31,92,31,146,31,71,31,16,31,229,31,23,31,23,30,164,31,15,31,15,30,218,31,236,31,33,31,128,31,84,31,22,31,22,30,22,29,22,28,6,31,95,31,105,31,48,31,82,31,137,31,182,31,182,30,60,31,183,31,113,31,113,30,253,31,253,30,182,31,127,31,173,31,58,31,222,31,38,31,38,30,84,31,34,31,210,31,203,31,90,31,203,31,128,31,173,31,72,31,55,31,55,30,227,31,227,30,249,31,249,30,104,31,30,31,73,31,151,31,164,31,37,31,177,31,199,31,186,31,231,31,39,31,39,30,241,31,241,30,253,31,220,31,166,31,220,31,220,30,64,31,168,31,168,30,240,31,77,31,77,30,253,31,27,31,231,31,231,30,231,29,231,28,231,27,65,31,69,31,111,31,213,31,172,31,22,31,209,31,143,31,84,31,138,31,166,31,120,31,120,30,120,29,136,31,177,31,172,31,77,31,116,31,68,31,153,31,136,31,128,31,66,31,69,31,243,31,223,31,6,31,17,31,189,31,106,31,36,31,36,30,169,31,174,31,174,30,128,31,181,31,136,31,20,31,24,31,136,31,136,30,233,31,22,31,140,31,212,31,65,31,142,31,142,30,142,29,206,31,206,30,76,31,158,31,83,31,155,31,182,31,87,31,190,31,225,31,123,31,116,31,171,31,71,31,71,30,4,31,181,31,85,31,57,31,57,30,145,31,213,31,79,31,200,31,209,31,193,31,11,31,11,30,9,31,67,31,254,31,10,31,148,31,124,31,161,31,238,31,238,30,243,31,86,31,122,31,122,30,245,31,214,31,83,31,112,31,44,31,68,31,208,31,167,31,167,30,68,31,68,30,214,31,130,31,56,31,250,31,223,31,223,30,26,31,191,31,233,31,51,31,255,31,68,31,178,31,190,31,213,31,50,31,10,31,134,31,69,31,233,31,44,31,96,31,93,31,93,30,101,31,54,31,180,31,12,31,159,31,81,31,158,31,158,30,45,31,31,31,67,31,149,31,170,31,170,30,248,31,134,31,25,31,34,31,119,31,67,31,164,31,69,31,202,31,127,31,146,31,179,31,167,31,198,31,173,31,217,31,205,31,14,31,14,30,240,31,234,31,231,31,172,31,91,31,83,31,7,31,24,31,24,30,254,31,249,31,249,30,2,31,19,31,109,31,151,31,244,31,6,31,248,31,248,30,1,31,186,31,56,31,100,31,139,31,98,31,248,31,195,31,187,31,230,31,255,31,43,31,144,31,14,31,255,31,52,31,52,30,52,29,233,31,116,31,34,31,33,31,46,31,216,31,186,31,72,31,61,31,61,30,61,29,196,31,15,31,18,31,158,31,54,31,82,31,57,31,169,31,49,31,7,31,104,31,99,31,229,31,1,31,93,31,93,30,86,31,2,31,14,31,14,30,136,31,96,31,59,31,126,31,18,31,132,31,12,31,16,31,137,31,215,31,125,31,35,31,213,31,118,31,98,31,249,31,195,31,195,30,93,31,186,31,168,31,168,30,168,29,168,28,215,31,215,30,49,31,159,31,159,30,174,31,174,30,67,31,97,31,117,31,61,31,186,31,221,31,198,31,12,31,50,31,50,30,193,31,149,31,88,31,191,31,123,31,123,30,73,31,92,31,89,31,218,31,92,31,92,30,66,31,125,31);

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
