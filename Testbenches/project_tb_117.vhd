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

constant SCENARIO_LENGTH : integer := 256;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (234,0,41,0,168,0,2,0,0,0,249,0,0,0,22,0,0,0,89,0,0,0,41,0,166,0,0,0,53,0,142,0,125,0,232,0,0,0,80,0,169,0,177,0,0,0,233,0,0,0,149,0,141,0,0,0,131,0,156,0,0,0,148,0,13,0,112,0,24,0,232,0,252,0,71,0,0,0,187,0,165,0,105,0,201,0,252,0,0,0,44,0,126,0,106,0,93,0,0,0,138,0,0,0,250,0,170,0,46,0,206,0,0,0,244,0,99,0,229,0,247,0,0,0,109,0,106,0,234,0,105,0,238,0,59,0,0,0,82,0,0,0,160,0,0,0,95,0,209,0,148,0,0,0,48,0,43,0,250,0,17,0,33,0,34,0,86,0,4,0,0,0,122,0,133,0,0,0,45,0,0,0,0,0,227,0,185,0,168,0,154,0,111,0,208,0,77,0,203,0,143,0,0,0,162,0,209,0,1,0,211,0,128,0,50,0,41,0,145,0,98,0,0,0,188,0,191,0,128,0,141,0,0,0,181,0,126,0,0,0,104,0,0,0,208,0,0,0,0,0,75,0,124,0,196,0,146,0,0,0,207,0,8,0,95,0,107,0,184,0,65,0,107,0,11,0,37,0,0,0,179,0,118,0,105,0,180,0,192,0,0,0,101,0,72,0,90,0,0,0,211,0,235,0,102,0,37,0,222,0,0,0,100,0,80,0,0,0,60,0,0,0,0,0,12,0,23,0,0,0,183,0,0,0,234,0,141,0,89,0,0,0,91,0,161,0,198,0,112,0,192,0,43,0,1,0,215,0,166,0,230,0,238,0,0,0,196,0,228,0,209,0,227,0,107,0,163,0,0,0,111,0,136,0,7,0,178,0,59,0,163,0,189,0,6,0,117,0,27,0,199,0,202,0,38,0,237,0,183,0,190,0,255,0,193,0,86,0,0,0,0,0,62,0,0,0,0,0,146,0,77,0,185,0,123,0,184,0,0,0,0,0,105,0,62,0,194,0,6,0,204,0,126,0,34,0,0,0,217,0,155,0,16,0,0,0,200,0,81,0,208,0,161,0,60,0,137,0,0,0,99,0,25,0,194,0,153,0,0,0,186,0,0,0,242,0,130,0,108,0,95,0,93,0,212,0,2,0,8,0,69,0);
signal scenario_full  : scenario_type := (234,31,41,31,168,31,2,31,2,30,249,31,249,30,22,31,22,30,89,31,89,30,41,31,166,31,166,30,53,31,142,31,125,31,232,31,232,30,80,31,169,31,177,31,177,30,233,31,233,30,149,31,141,31,141,30,131,31,156,31,156,30,148,31,13,31,112,31,24,31,232,31,252,31,71,31,71,30,187,31,165,31,105,31,201,31,252,31,252,30,44,31,126,31,106,31,93,31,93,30,138,31,138,30,250,31,170,31,46,31,206,31,206,30,244,31,99,31,229,31,247,31,247,30,109,31,106,31,234,31,105,31,238,31,59,31,59,30,82,31,82,30,160,31,160,30,95,31,209,31,148,31,148,30,48,31,43,31,250,31,17,31,33,31,34,31,86,31,4,31,4,30,122,31,133,31,133,30,45,31,45,30,45,29,227,31,185,31,168,31,154,31,111,31,208,31,77,31,203,31,143,31,143,30,162,31,209,31,1,31,211,31,128,31,50,31,41,31,145,31,98,31,98,30,188,31,191,31,128,31,141,31,141,30,181,31,126,31,126,30,104,31,104,30,208,31,208,30,208,29,75,31,124,31,196,31,146,31,146,30,207,31,8,31,95,31,107,31,184,31,65,31,107,31,11,31,37,31,37,30,179,31,118,31,105,31,180,31,192,31,192,30,101,31,72,31,90,31,90,30,211,31,235,31,102,31,37,31,222,31,222,30,100,31,80,31,80,30,60,31,60,30,60,29,12,31,23,31,23,30,183,31,183,30,234,31,141,31,89,31,89,30,91,31,161,31,198,31,112,31,192,31,43,31,1,31,215,31,166,31,230,31,238,31,238,30,196,31,228,31,209,31,227,31,107,31,163,31,163,30,111,31,136,31,7,31,178,31,59,31,163,31,189,31,6,31,117,31,27,31,199,31,202,31,38,31,237,31,183,31,190,31,255,31,193,31,86,31,86,30,86,29,62,31,62,30,62,29,146,31,77,31,185,31,123,31,184,31,184,30,184,29,105,31,62,31,194,31,6,31,204,31,126,31,34,31,34,30,217,31,155,31,16,31,16,30,200,31,81,31,208,31,161,31,60,31,137,31,137,30,99,31,25,31,194,31,153,31,153,30,186,31,186,30,242,31,130,31,108,31,95,31,93,31,212,31,2,31,8,31,69,31);

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
