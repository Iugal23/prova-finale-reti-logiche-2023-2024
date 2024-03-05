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

constant SCENARIO_LENGTH : integer := 398;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (4,0,241,0,193,0,62,0,141,0,90,0,0,0,251,0,15,0,22,0,53,0,129,0,252,0,73,0,169,0,134,0,79,0,20,0,0,0,80,0,57,0,83,0,251,0,67,0,168,0,140,0,203,0,178,0,5,0,0,0,193,0,87,0,0,0,47,0,11,0,0,0,200,0,106,0,78,0,69,0,98,0,0,0,35,0,102,0,0,0,166,0,0,0,179,0,117,0,21,0,230,0,4,0,227,0,0,0,0,0,109,0,20,0,72,0,194,0,250,0,0,0,125,0,177,0,69,0,161,0,0,0,241,0,207,0,238,0,198,0,47,0,240,0,247,0,86,0,212,0,0,0,0,0,0,0,229,0,97,0,108,0,20,0,94,0,214,0,235,0,235,0,0,0,7,0,155,0,0,0,80,0,226,0,187,0,94,0,136,0,248,0,5,0,170,0,172,0,0,0,197,0,0,0,87,0,32,0,165,0,2,0,175,0,0,0,0,0,202,0,126,0,113,0,100,0,174,0,243,0,147,0,3,0,101,0,62,0,48,0,55,0,30,0,151,0,173,0,62,0,0,0,246,0,113,0,116,0,228,0,205,0,79,0,0,0,8,0,0,0,211,0,89,0,123,0,0,0,79,0,6,0,1,0,12,0,92,0,30,0,213,0,92,0,32,0,38,0,47,0,117,0,5,0,28,0,2,0,45,0,0,0,76,0,66,0,134,0,0,0,90,0,31,0,178,0,123,0,155,0,220,0,195,0,134,0,143,0,85,0,204,0,69,0,171,0,154,0,145,0,129,0,181,0,0,0,0,0,0,0,91,0,0,0,212,0,0,0,217,0,86,0,24,0,120,0,144,0,84,0,71,0,171,0,217,0,220,0,106,0,0,0,19,0,232,0,73,0,204,0,228,0,41,0,0,0,0,0,190,0,55,0,58,0,178,0,3,0,174,0,246,0,0,0,41,0,242,0,198,0,0,0,82,0,0,0,46,0,211,0,152,0,234,0,94,0,194,0,0,0,198,0,198,0,169,0,67,0,20,0,0,0,179,0,50,0,183,0,54,0,194,0,164,0,0,0,0,0,209,0,61,0,188,0,147,0,239,0,96,0,22,0,206,0,179,0,255,0,76,0,0,0,114,0,186,0,142,0,18,0,76,0,103,0,97,0,57,0,0,0,112,0,0,0,87,0,0,0,0,0,156,0,91,0,0,0,0,0,0,0,6,0,31,0,132,0,0,0,14,0,54,0,212,0,24,0,65,0,141,0,170,0,19,0,84,0,0,0,80,0,202,0,16,0,67,0,15,0,214,0,102,0,194,0,0,0,71,0,159,0,2,0,228,0,25,0,246,0,181,0,164,0,225,0,3,0,222,0,221,0,0,0,240,0,202,0,24,0,225,0,130,0,7,0,0,0,191,0,0,0,91,0,223,0,166,0,0,0,0,0,152,0,15,0,172,0,114,0,236,0,140,0,99,0,17,0,143,0,7,0,143,0,232,0,117,0,185,0,0,0,192,0,133,0,0,0,249,0,202,0,202,0,0,0,0,0,229,0,0,0,217,0,124,0,0,0,107,0,0,0,55,0,0,0,255,0,0,0,181,0,57,0,0,0,159,0,0,0,214,0,152,0,208,0,5,0,9,0,141,0,0,0,50,0,135,0,122,0,56,0,145,0,59,0,55,0,0,0,88,0,90,0,0,0,177,0,49,0,94,0,102,0,0,0,27,0,43,0,105,0,50,0,0,0,171,0,207,0,240,0,0,0,198,0,199,0,6,0,73,0,56,0,106,0,250,0);
signal scenario_full  : scenario_type := (4,31,241,31,193,31,62,31,141,31,90,31,90,30,251,31,15,31,22,31,53,31,129,31,252,31,73,31,169,31,134,31,79,31,20,31,20,30,80,31,57,31,83,31,251,31,67,31,168,31,140,31,203,31,178,31,5,31,5,30,193,31,87,31,87,30,47,31,11,31,11,30,200,31,106,31,78,31,69,31,98,31,98,30,35,31,102,31,102,30,166,31,166,30,179,31,117,31,21,31,230,31,4,31,227,31,227,30,227,29,109,31,20,31,72,31,194,31,250,31,250,30,125,31,177,31,69,31,161,31,161,30,241,31,207,31,238,31,198,31,47,31,240,31,247,31,86,31,212,31,212,30,212,29,212,28,229,31,97,31,108,31,20,31,94,31,214,31,235,31,235,31,235,30,7,31,155,31,155,30,80,31,226,31,187,31,94,31,136,31,248,31,5,31,170,31,172,31,172,30,197,31,197,30,87,31,32,31,165,31,2,31,175,31,175,30,175,29,202,31,126,31,113,31,100,31,174,31,243,31,147,31,3,31,101,31,62,31,48,31,55,31,30,31,151,31,173,31,62,31,62,30,246,31,113,31,116,31,228,31,205,31,79,31,79,30,8,31,8,30,211,31,89,31,123,31,123,30,79,31,6,31,1,31,12,31,92,31,30,31,213,31,92,31,32,31,38,31,47,31,117,31,5,31,28,31,2,31,45,31,45,30,76,31,66,31,134,31,134,30,90,31,31,31,178,31,123,31,155,31,220,31,195,31,134,31,143,31,85,31,204,31,69,31,171,31,154,31,145,31,129,31,181,31,181,30,181,29,181,28,91,31,91,30,212,31,212,30,217,31,86,31,24,31,120,31,144,31,84,31,71,31,171,31,217,31,220,31,106,31,106,30,19,31,232,31,73,31,204,31,228,31,41,31,41,30,41,29,190,31,55,31,58,31,178,31,3,31,174,31,246,31,246,30,41,31,242,31,198,31,198,30,82,31,82,30,46,31,211,31,152,31,234,31,94,31,194,31,194,30,198,31,198,31,169,31,67,31,20,31,20,30,179,31,50,31,183,31,54,31,194,31,164,31,164,30,164,29,209,31,61,31,188,31,147,31,239,31,96,31,22,31,206,31,179,31,255,31,76,31,76,30,114,31,186,31,142,31,18,31,76,31,103,31,97,31,57,31,57,30,112,31,112,30,87,31,87,30,87,29,156,31,91,31,91,30,91,29,91,28,6,31,31,31,132,31,132,30,14,31,54,31,212,31,24,31,65,31,141,31,170,31,19,31,84,31,84,30,80,31,202,31,16,31,67,31,15,31,214,31,102,31,194,31,194,30,71,31,159,31,2,31,228,31,25,31,246,31,181,31,164,31,225,31,3,31,222,31,221,31,221,30,240,31,202,31,24,31,225,31,130,31,7,31,7,30,191,31,191,30,91,31,223,31,166,31,166,30,166,29,152,31,15,31,172,31,114,31,236,31,140,31,99,31,17,31,143,31,7,31,143,31,232,31,117,31,185,31,185,30,192,31,133,31,133,30,249,31,202,31,202,31,202,30,202,29,229,31,229,30,217,31,124,31,124,30,107,31,107,30,55,31,55,30,255,31,255,30,181,31,57,31,57,30,159,31,159,30,214,31,152,31,208,31,5,31,9,31,141,31,141,30,50,31,135,31,122,31,56,31,145,31,59,31,55,31,55,30,88,31,90,31,90,30,177,31,49,31,94,31,102,31,102,30,27,31,43,31,105,31,50,31,50,30,171,31,207,31,240,31,240,30,198,31,199,31,6,31,73,31,56,31,106,31,250,31);

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
