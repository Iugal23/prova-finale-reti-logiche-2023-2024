-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_476 is
end project_tb_476;

architecture project_tb_arch_476 of project_tb_476 is
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

constant SCENARIO_LENGTH : integer := 552;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (165,0,0,0,0,0,88,0,185,0,100,0,0,0,167,0,117,0,217,0,171,0,132,0,3,0,0,0,65,0,249,0,85,0,46,0,50,0,181,0,232,0,121,0,0,0,151,0,224,0,58,0,41,0,161,0,219,0,217,0,25,0,133,0,118,0,223,0,170,0,113,0,48,0,0,0,59,0,198,0,36,0,113,0,222,0,88,0,147,0,199,0,175,0,109,0,0,0,170,0,36,0,253,0,148,0,139,0,215,0,79,0,61,0,145,0,251,0,250,0,144,0,110,0,11,0,183,0,94,0,93,0,0,0,134,0,0,0,0,0,0,0,190,0,214,0,0,0,33,0,165,0,68,0,165,0,164,0,58,0,203,0,7,0,0,0,0,0,65,0,236,0,11,0,210,0,27,0,60,0,119,0,116,0,118,0,0,0,133,0,48,0,251,0,112,0,95,0,0,0,0,0,193,0,94,0,190,0,0,0,126,0,154,0,249,0,135,0,25,0,105,0,38,0,151,0,92,0,0,0,111,0,173,0,0,0,0,0,179,0,31,0,251,0,0,0,22,0,161,0,75,0,0,0,171,0,126,0,165,0,80,0,0,0,210,0,0,0,49,0,212,0,0,0,190,0,189,0,0,0,107,0,211,0,0,0,145,0,191,0,59,0,0,0,188,0,6,0,171,0,187,0,120,0,244,0,105,0,248,0,0,0,121,0,0,0,105,0,100,0,29,0,34,0,216,0,36,0,46,0,99,0,108,0,147,0,74,0,183,0,116,0,221,0,0,0,203,0,82,0,130,0,99,0,0,0,132,0,76,0,80,0,209,0,0,0,0,0,0,0,75,0,125,0,0,0,254,0,132,0,0,0,0,0,163,0,66,0,110,0,38,0,87,0,194,0,136,0,137,0,223,0,22,0,134,0,38,0,5,0,0,0,173,0,89,0,200,0,31,0,0,0,232,0,16,0,57,0,0,0,22,0,180,0,220,0,176,0,53,0,102,0,104,0,133,0,74,0,220,0,162,0,159,0,227,0,163,0,0,0,23,0,56,0,0,0,0,0,157,0,49,0,84,0,0,0,188,0,6,0,244,0,120,0,0,0,22,0,112,0,10,0,192,0,0,0,0,0,15,0,97,0,107,0,0,0,3,0,96,0,77,0,55,0,201,0,218,0,55,0,0,0,237,0,110,0,0,0,226,0,96,0,179,0,229,0,195,0,77,0,175,0,240,0,116,0,188,0,244,0,0,0,79,0,192,0,83,0,25,0,76,0,89,0,0,0,182,0,171,0,0,0,241,0,95,0,170,0,0,0,135,0,245,0,98,0,185,0,194,0,0,0,141,0,138,0,151,0,54,0,164,0,22,0,15,0,98,0,91,0,86,0,64,0,150,0,46,0,0,0,207,0,0,0,0,0,168,0,0,0,0,0,127,0,56,0,0,0,34,0,95,0,141,0,162,0,59,0,207,0,75,0,133,0,0,0,254,0,0,0,0,0,157,0,0,0,165,0,74,0,14,0,165,0,75,0,0,0,148,0,178,0,194,0,3,0,60,0,220,0,48,0,191,0,240,0,0,0,217,0,231,0,0,0,223,0,246,0,0,0,33,0,220,0,62,0,165,0,232,0,251,0,0,0,40,0,0,0,67,0,57,0,172,0,137,0,79,0,223,0,101,0,164,0,0,0,49,0,166,0,241,0,62,0,0,0,36,0,98,0,135,0,0,0,192,0,22,0,188,0,9,0,250,0,206,0,37,0,0,0,193,0,89,0,50,0,109,0,145,0,64,0,166,0,2,0,114,0,21,0,173,0,48,0,0,0,0,0,201,0,167,0,20,0,47,0,232,0,87,0,175,0,0,0,0,0,79,0,188,0,97,0,0,0,141,0,120,0,149,0,75,0,0,0,0,0,21,0,76,0,108,0,88,0,81,0,35,0,33,0,84,0,11,0,0,0,157,0,222,0,137,0,164,0,219,0,172,0,27,0,70,0,10,0,218,0,183,0,3,0,32,0,0,0,23,0,16,0,231,0,25,0,39,0,9,0,128,0,84,0,47,0,107,0,102,0,188,0,0,0,8,0,102,0,7,0,119,0,164,0,0,0,19,0,0,0,114,0,0,0,0,0,0,0,162,0,153,0,74,0,109,0,51,0,185,0,246,0,36,0,48,0,78,0,0,0,0,0,35,0,75,0,219,0,78,0,191,0,24,0,180,0,0,0,138,0,122,0,75,0,246,0,209,0,203,0,0,0,0,0,0,0,12,0,91,0,114,0,117,0,185,0,117,0,196,0,250,0,0,0,240,0,29,0,0,0,217,0,155,0,99,0,0,0,223,0,235,0,0,0,110,0,0,0,84,0,0,0,92,0,130,0,0,0,76,0,0,0,182,0,108,0,66,0,131,0,126,0,252,0,210,0,109,0,6,0,41,0,111,0,72,0,0,0,36,0,0,0,123,0,54,0,106,0,80,0,226,0,11,0,0,0,130,0);
signal scenario_full  : scenario_type := (165,31,165,30,165,29,88,31,185,31,100,31,100,30,167,31,117,31,217,31,171,31,132,31,3,31,3,30,65,31,249,31,85,31,46,31,50,31,181,31,232,31,121,31,121,30,151,31,224,31,58,31,41,31,161,31,219,31,217,31,25,31,133,31,118,31,223,31,170,31,113,31,48,31,48,30,59,31,198,31,36,31,113,31,222,31,88,31,147,31,199,31,175,31,109,31,109,30,170,31,36,31,253,31,148,31,139,31,215,31,79,31,61,31,145,31,251,31,250,31,144,31,110,31,11,31,183,31,94,31,93,31,93,30,134,31,134,30,134,29,134,28,190,31,214,31,214,30,33,31,165,31,68,31,165,31,164,31,58,31,203,31,7,31,7,30,7,29,65,31,236,31,11,31,210,31,27,31,60,31,119,31,116,31,118,31,118,30,133,31,48,31,251,31,112,31,95,31,95,30,95,29,193,31,94,31,190,31,190,30,126,31,154,31,249,31,135,31,25,31,105,31,38,31,151,31,92,31,92,30,111,31,173,31,173,30,173,29,179,31,31,31,251,31,251,30,22,31,161,31,75,31,75,30,171,31,126,31,165,31,80,31,80,30,210,31,210,30,49,31,212,31,212,30,190,31,189,31,189,30,107,31,211,31,211,30,145,31,191,31,59,31,59,30,188,31,6,31,171,31,187,31,120,31,244,31,105,31,248,31,248,30,121,31,121,30,105,31,100,31,29,31,34,31,216,31,36,31,46,31,99,31,108,31,147,31,74,31,183,31,116,31,221,31,221,30,203,31,82,31,130,31,99,31,99,30,132,31,76,31,80,31,209,31,209,30,209,29,209,28,75,31,125,31,125,30,254,31,132,31,132,30,132,29,163,31,66,31,110,31,38,31,87,31,194,31,136,31,137,31,223,31,22,31,134,31,38,31,5,31,5,30,173,31,89,31,200,31,31,31,31,30,232,31,16,31,57,31,57,30,22,31,180,31,220,31,176,31,53,31,102,31,104,31,133,31,74,31,220,31,162,31,159,31,227,31,163,31,163,30,23,31,56,31,56,30,56,29,157,31,49,31,84,31,84,30,188,31,6,31,244,31,120,31,120,30,22,31,112,31,10,31,192,31,192,30,192,29,15,31,97,31,107,31,107,30,3,31,96,31,77,31,55,31,201,31,218,31,55,31,55,30,237,31,110,31,110,30,226,31,96,31,179,31,229,31,195,31,77,31,175,31,240,31,116,31,188,31,244,31,244,30,79,31,192,31,83,31,25,31,76,31,89,31,89,30,182,31,171,31,171,30,241,31,95,31,170,31,170,30,135,31,245,31,98,31,185,31,194,31,194,30,141,31,138,31,151,31,54,31,164,31,22,31,15,31,98,31,91,31,86,31,64,31,150,31,46,31,46,30,207,31,207,30,207,29,168,31,168,30,168,29,127,31,56,31,56,30,34,31,95,31,141,31,162,31,59,31,207,31,75,31,133,31,133,30,254,31,254,30,254,29,157,31,157,30,165,31,74,31,14,31,165,31,75,31,75,30,148,31,178,31,194,31,3,31,60,31,220,31,48,31,191,31,240,31,240,30,217,31,231,31,231,30,223,31,246,31,246,30,33,31,220,31,62,31,165,31,232,31,251,31,251,30,40,31,40,30,67,31,57,31,172,31,137,31,79,31,223,31,101,31,164,31,164,30,49,31,166,31,241,31,62,31,62,30,36,31,98,31,135,31,135,30,192,31,22,31,188,31,9,31,250,31,206,31,37,31,37,30,193,31,89,31,50,31,109,31,145,31,64,31,166,31,2,31,114,31,21,31,173,31,48,31,48,30,48,29,201,31,167,31,20,31,47,31,232,31,87,31,175,31,175,30,175,29,79,31,188,31,97,31,97,30,141,31,120,31,149,31,75,31,75,30,75,29,21,31,76,31,108,31,88,31,81,31,35,31,33,31,84,31,11,31,11,30,157,31,222,31,137,31,164,31,219,31,172,31,27,31,70,31,10,31,218,31,183,31,3,31,32,31,32,30,23,31,16,31,231,31,25,31,39,31,9,31,128,31,84,31,47,31,107,31,102,31,188,31,188,30,8,31,102,31,7,31,119,31,164,31,164,30,19,31,19,30,114,31,114,30,114,29,114,28,162,31,153,31,74,31,109,31,51,31,185,31,246,31,36,31,48,31,78,31,78,30,78,29,35,31,75,31,219,31,78,31,191,31,24,31,180,31,180,30,138,31,122,31,75,31,246,31,209,31,203,31,203,30,203,29,203,28,12,31,91,31,114,31,117,31,185,31,117,31,196,31,250,31,250,30,240,31,29,31,29,30,217,31,155,31,99,31,99,30,223,31,235,31,235,30,110,31,110,30,84,31,84,30,92,31,130,31,130,30,76,31,76,30,182,31,108,31,66,31,131,31,126,31,252,31,210,31,109,31,6,31,41,31,111,31,72,31,72,30,36,31,36,30,123,31,54,31,106,31,80,31,226,31,11,31,11,30,130,31);

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
