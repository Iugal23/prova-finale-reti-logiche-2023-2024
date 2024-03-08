-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_514 is
end project_tb_514;

architecture project_tb_arch_514 of project_tb_514 is
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

constant SCENARIO_LENGTH : integer := 408;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (130,0,182,0,0,0,195,0,175,0,0,0,0,0,144,0,221,0,185,0,141,0,230,0,233,0,34,0,0,0,34,0,0,0,27,0,0,0,134,0,112,0,96,0,118,0,147,0,167,0,0,0,0,0,209,0,188,0,12,0,171,0,0,0,158,0,228,0,147,0,156,0,178,0,255,0,94,0,10,0,205,0,98,0,51,0,48,0,0,0,120,0,171,0,7,0,126,0,229,0,0,0,239,0,35,0,0,0,0,0,27,0,0,0,159,0,198,0,0,0,210,0,0,0,204,0,0,0,73,0,43,0,195,0,123,0,0,0,125,0,29,0,20,0,0,0,85,0,131,0,81,0,10,0,238,0,62,0,152,0,92,0,88,0,209,0,123,0,14,0,114,0,236,0,57,0,188,0,68,0,239,0,31,0,0,0,223,0,7,0,0,0,213,0,0,0,22,0,229,0,159,0,0,0,239,0,59,0,245,0,8,0,201,0,160,0,76,0,88,0,208,0,0,0,199,0,7,0,53,0,203,0,0,0,0,0,0,0,53,0,31,0,0,0,54,0,0,0,0,0,0,0,54,0,225,0,111,0,0,0,166,0,99,0,75,0,71,0,231,0,225,0,125,0,56,0,0,0,227,0,185,0,156,0,234,0,64,0,72,0,0,0,0,0,0,0,21,0,247,0,109,0,2,0,0,0,108,0,52,0,192,0,202,0,144,0,108,0,0,0,27,0,68,0,94,0,0,0,0,0,198,0,135,0,4,0,0,0,0,0,0,0,194,0,253,0,46,0,0,0,128,0,214,0,193,0,181,0,66,0,0,0,147,0,175,0,10,0,246,0,10,0,0,0,0,0,206,0,190,0,22,0,135,0,92,0,236,0,197,0,0,0,61,0,0,0,60,0,65,0,158,0,158,0,156,0,201,0,54,0,197,0,92,0,215,0,0,0,62,0,124,0,64,0,197,0,22,0,249,0,129,0,0,0,0,0,176,0,212,0,0,0,230,0,0,0,0,0,179,0,209,0,127,0,0,0,101,0,254,0,156,0,0,0,233,0,220,0,237,0,245,0,0,0,0,0,124,0,56,0,99,0,185,0,82,0,143,0,201,0,224,0,152,0,183,0,13,0,14,0,19,0,160,0,178,0,0,0,145,0,99,0,0,0,34,0,7,0,125,0,127,0,61,0,64,0,0,0,172,0,121,0,4,0,159,0,0,0,215,0,167,0,247,0,34,0,21,0,206,0,237,0,0,0,83,0,138,0,0,0,51,0,64,0,9,0,179,0,231,0,101,0,251,0,0,0,136,0,245,0,191,0,60,0,54,0,221,0,71,0,0,0,42,0,218,0,128,0,0,0,55,0,134,0,191,0,160,0,210,0,148,0,132,0,156,0,0,0,0,0,204,0,0,0,0,0,5,0,252,0,107,0,139,0,239,0,0,0,111,0,170,0,37,0,193,0,223,0,75,0,0,0,106,0,1,0,35,0,91,0,140,0,241,0,232,0,0,0,0,0,171,0,82,0,187,0,79,0,196,0,56,0,84,0,13,0,234,0,34,0,0,0,0,0,226,0,246,0,103,0,9,0,0,0,32,0,0,0,192,0,73,0,0,0,222,0,21,0,198,0,0,0,219,0,179,0,117,0,122,0,33,0,55,0,101,0,112,0,219,0,135,0,146,0,45,0,0,0,0,0,0,0,66,0,243,0,82,0,9,0,8,0,188,0,187,0,0,0,104,0,0,0,0,0,61,0,120,0,133,0,155,0,219,0,115,0,51,0,106,0,194,0,41,0,141,0,253,0,77,0,197,0,0,0,0,0,0,0,222,0,119,0,181,0,48,0);
signal scenario_full  : scenario_type := (130,31,182,31,182,30,195,31,175,31,175,30,175,29,144,31,221,31,185,31,141,31,230,31,233,31,34,31,34,30,34,31,34,30,27,31,27,30,134,31,112,31,96,31,118,31,147,31,167,31,167,30,167,29,209,31,188,31,12,31,171,31,171,30,158,31,228,31,147,31,156,31,178,31,255,31,94,31,10,31,205,31,98,31,51,31,48,31,48,30,120,31,171,31,7,31,126,31,229,31,229,30,239,31,35,31,35,30,35,29,27,31,27,30,159,31,198,31,198,30,210,31,210,30,204,31,204,30,73,31,43,31,195,31,123,31,123,30,125,31,29,31,20,31,20,30,85,31,131,31,81,31,10,31,238,31,62,31,152,31,92,31,88,31,209,31,123,31,14,31,114,31,236,31,57,31,188,31,68,31,239,31,31,31,31,30,223,31,7,31,7,30,213,31,213,30,22,31,229,31,159,31,159,30,239,31,59,31,245,31,8,31,201,31,160,31,76,31,88,31,208,31,208,30,199,31,7,31,53,31,203,31,203,30,203,29,203,28,53,31,31,31,31,30,54,31,54,30,54,29,54,28,54,31,225,31,111,31,111,30,166,31,99,31,75,31,71,31,231,31,225,31,125,31,56,31,56,30,227,31,185,31,156,31,234,31,64,31,72,31,72,30,72,29,72,28,21,31,247,31,109,31,2,31,2,30,108,31,52,31,192,31,202,31,144,31,108,31,108,30,27,31,68,31,94,31,94,30,94,29,198,31,135,31,4,31,4,30,4,29,4,28,194,31,253,31,46,31,46,30,128,31,214,31,193,31,181,31,66,31,66,30,147,31,175,31,10,31,246,31,10,31,10,30,10,29,206,31,190,31,22,31,135,31,92,31,236,31,197,31,197,30,61,31,61,30,60,31,65,31,158,31,158,31,156,31,201,31,54,31,197,31,92,31,215,31,215,30,62,31,124,31,64,31,197,31,22,31,249,31,129,31,129,30,129,29,176,31,212,31,212,30,230,31,230,30,230,29,179,31,209,31,127,31,127,30,101,31,254,31,156,31,156,30,233,31,220,31,237,31,245,31,245,30,245,29,124,31,56,31,99,31,185,31,82,31,143,31,201,31,224,31,152,31,183,31,13,31,14,31,19,31,160,31,178,31,178,30,145,31,99,31,99,30,34,31,7,31,125,31,127,31,61,31,64,31,64,30,172,31,121,31,4,31,159,31,159,30,215,31,167,31,247,31,34,31,21,31,206,31,237,31,237,30,83,31,138,31,138,30,51,31,64,31,9,31,179,31,231,31,101,31,251,31,251,30,136,31,245,31,191,31,60,31,54,31,221,31,71,31,71,30,42,31,218,31,128,31,128,30,55,31,134,31,191,31,160,31,210,31,148,31,132,31,156,31,156,30,156,29,204,31,204,30,204,29,5,31,252,31,107,31,139,31,239,31,239,30,111,31,170,31,37,31,193,31,223,31,75,31,75,30,106,31,1,31,35,31,91,31,140,31,241,31,232,31,232,30,232,29,171,31,82,31,187,31,79,31,196,31,56,31,84,31,13,31,234,31,34,31,34,30,34,29,226,31,246,31,103,31,9,31,9,30,32,31,32,30,192,31,73,31,73,30,222,31,21,31,198,31,198,30,219,31,179,31,117,31,122,31,33,31,55,31,101,31,112,31,219,31,135,31,146,31,45,31,45,30,45,29,45,28,66,31,243,31,82,31,9,31,8,31,188,31,187,31,187,30,104,31,104,30,104,29,61,31,120,31,133,31,155,31,219,31,115,31,51,31,106,31,194,31,41,31,141,31,253,31,77,31,197,31,197,30,197,29,197,28,222,31,119,31,181,31,48,31);

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
