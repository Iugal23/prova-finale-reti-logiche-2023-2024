-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_352 is
end project_tb_352;

architecture project_tb_arch_352 of project_tb_352 is
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

constant SCENARIO_LENGTH : integer := 612;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (194,0,0,0,39,0,194,0,145,0,0,0,243,0,82,0,81,0,174,0,150,0,221,0,180,0,0,0,104,0,106,0,108,0,150,0,105,0,50,0,0,0,9,0,172,0,122,0,182,0,72,0,106,0,0,0,89,0,0,0,32,0,238,0,90,0,53,0,154,0,0,0,24,0,182,0,99,0,171,0,0,0,0,0,174,0,73,0,53,0,126,0,109,0,250,0,136,0,0,0,0,0,214,0,105,0,42,0,28,0,207,0,127,0,49,0,35,0,163,0,31,0,0,0,0,0,101,0,143,0,0,0,0,0,0,0,111,0,227,0,142,0,0,0,73,0,108,0,215,0,234,0,0,0,196,0,0,0,37,0,227,0,0,0,60,0,20,0,28,0,33,0,153,0,21,0,146,0,42,0,0,0,102,0,25,0,160,0,0,0,2,0,181,0,221,0,132,0,0,0,0,0,169,0,85,0,15,0,242,0,89,0,109,0,96,0,76,0,171,0,72,0,0,0,121,0,166,0,242,0,226,0,111,0,184,0,34,0,0,0,198,0,46,0,23,0,42,0,216,0,35,0,4,0,163,0,12,0,28,0,4,0,174,0,102,0,53,0,203,0,134,0,0,0,232,0,0,0,0,0,212,0,32,0,0,0,112,0,46,0,12,0,98,0,160,0,13,0,15,0,218,0,191,0,211,0,221,0,6,0,93,0,159,0,173,0,0,0,208,0,149,0,248,0,163,0,18,0,8,0,20,0,70,0,3,0,0,0,132,0,169,0,201,0,234,0,208,0,246,0,70,0,17,0,0,0,0,0,67,0,0,0,25,0,110,0,16,0,2,0,122,0,218,0,225,0,194,0,153,0,73,0,21,0,132,0,222,0,0,0,233,0,160,0,0,0,162,0,0,0,129,0,61,0,0,0,0,0,126,0,32,0,178,0,0,0,55,0,169,0,168,0,164,0,227,0,173,0,24,0,181,0,156,0,0,0,215,0,65,0,61,0,0,0,203,0,54,0,118,0,0,0,0,0,195,0,31,0,142,0,0,0,75,0,56,0,0,0,0,0,193,0,152,0,219,0,0,0,31,0,186,0,73,0,126,0,0,0,84,0,0,0,197,0,170,0,0,0,245,0,21,0,104,0,133,0,161,0,0,0,59,0,224,0,212,0,242,0,0,0,165,0,137,0,29,0,198,0,236,0,0,0,183,0,241,0,0,0,0,0,0,0,33,0,0,0,0,0,0,0,49,0,48,0,0,0,0,0,99,0,15,0,0,0,163,0,0,0,202,0,168,0,148,0,0,0,0,0,6,0,125,0,44,0,0,0,57,0,206,0,102,0,248,0,65,0,205,0,198,0,137,0,120,0,193,0,58,0,22,0,2,0,29,0,210,0,36,0,35,0,207,0,2,0,205,0,225,0,221,0,137,0,0,0,149,0,80,0,0,0,249,0,68,0,35,0,33,0,86,0,85,0,103,0,62,0,0,0,138,0,0,0,29,0,119,0,77,0,124,0,50,0,164,0,122,0,213,0,0,0,215,0,0,0,0,0,36,0,241,0,162,0,0,0,253,0,0,0,113,0,220,0,203,0,103,0,153,0,3,0,211,0,120,0,0,0,0,0,0,0,0,0,198,0,122,0,66,0,18,0,207,0,129,0,235,0,56,0,42,0,185,0,214,0,242,0,30,0,66,0,52,0,18,0,164,0,0,0,82,0,0,0,96,0,0,0,0,0,62,0,159,0,156,0,125,0,194,0,149,0,54,0,0,0,97,0,0,0,160,0,0,0,0,0,254,0,0,0,43,0,105,0,92,0,0,0,20,0,0,0,235,0,110,0,27,0,164,0,52,0,47,0,89,0,45,0,72,0,166,0,160,0,192,0,214,0,231,0,85,0,6,0,186,0,33,0,0,0,161,0,125,0,85,0,51,0,0,0,160,0,147,0,134,0,55,0,0,0,36,0,94,0,61,0,135,0,56,0,0,0,66,0,202,0,66,0,99,0,0,0,41,0,120,0,0,0,32,0,1,0,72,0,0,0,209,0,97,0,52,0,203,0,177,0,15,0,173,0,236,0,158,0,82,0,241,0,96,0,69,0,20,0,0,0,158,0,224,0,226,0,11,0,53,0,220,0,0,0,181,0,207,0,8,0,230,0,171,0,204,0,145,0,0,0,107,0,156,0,150,0,171,0,53,0,5,0,117,0,157,0,109,0,0,0,183,0,146,0,65,0,96,0,236,0,0,0,251,0,214,0,0,0,64,0,0,0,97,0,9,0,196,0,197,0,0,0,0,0,0,0,107,0,175,0,100,0,0,0,0,0,25,0,0,0,89,0,180,0,0,0,0,0,183,0,0,0,38,0,200,0,75,0,181,0,45,0,148,0,86,0,22,0,177,0,213,0,42,0,0,0,177,0,205,0,250,0,181,0,180,0,44,0,0,0,222,0,138,0,0,0,0,0,80,0,0,0,53,0,0,0,2,0,72,0,75,0,97,0,7,0,126,0,40,0,132,0,85,0,40,0,55,0,232,0,0,0,221,0,6,0,30,0,235,0,0,0,0,0,123,0,136,0,99,0,0,0,0,0,182,0,86,0,158,0,167,0,76,0,216,0,211,0,117,0,154,0,0,0,71,0,252,0,5,0,161,0,79,0,105,0,51,0,0,0,42,0,78,0,34,0,0,0,231,0,44,0,30,0,99,0,211,0,208,0,0,0,143,0,74,0,218,0,111,0,103,0,211,0,41,0,255,0,0,0);
signal scenario_full  : scenario_type := (194,31,194,30,39,31,194,31,145,31,145,30,243,31,82,31,81,31,174,31,150,31,221,31,180,31,180,30,104,31,106,31,108,31,150,31,105,31,50,31,50,30,9,31,172,31,122,31,182,31,72,31,106,31,106,30,89,31,89,30,32,31,238,31,90,31,53,31,154,31,154,30,24,31,182,31,99,31,171,31,171,30,171,29,174,31,73,31,53,31,126,31,109,31,250,31,136,31,136,30,136,29,214,31,105,31,42,31,28,31,207,31,127,31,49,31,35,31,163,31,31,31,31,30,31,29,101,31,143,31,143,30,143,29,143,28,111,31,227,31,142,31,142,30,73,31,108,31,215,31,234,31,234,30,196,31,196,30,37,31,227,31,227,30,60,31,20,31,28,31,33,31,153,31,21,31,146,31,42,31,42,30,102,31,25,31,160,31,160,30,2,31,181,31,221,31,132,31,132,30,132,29,169,31,85,31,15,31,242,31,89,31,109,31,96,31,76,31,171,31,72,31,72,30,121,31,166,31,242,31,226,31,111,31,184,31,34,31,34,30,198,31,46,31,23,31,42,31,216,31,35,31,4,31,163,31,12,31,28,31,4,31,174,31,102,31,53,31,203,31,134,31,134,30,232,31,232,30,232,29,212,31,32,31,32,30,112,31,46,31,12,31,98,31,160,31,13,31,15,31,218,31,191,31,211,31,221,31,6,31,93,31,159,31,173,31,173,30,208,31,149,31,248,31,163,31,18,31,8,31,20,31,70,31,3,31,3,30,132,31,169,31,201,31,234,31,208,31,246,31,70,31,17,31,17,30,17,29,67,31,67,30,25,31,110,31,16,31,2,31,122,31,218,31,225,31,194,31,153,31,73,31,21,31,132,31,222,31,222,30,233,31,160,31,160,30,162,31,162,30,129,31,61,31,61,30,61,29,126,31,32,31,178,31,178,30,55,31,169,31,168,31,164,31,227,31,173,31,24,31,181,31,156,31,156,30,215,31,65,31,61,31,61,30,203,31,54,31,118,31,118,30,118,29,195,31,31,31,142,31,142,30,75,31,56,31,56,30,56,29,193,31,152,31,219,31,219,30,31,31,186,31,73,31,126,31,126,30,84,31,84,30,197,31,170,31,170,30,245,31,21,31,104,31,133,31,161,31,161,30,59,31,224,31,212,31,242,31,242,30,165,31,137,31,29,31,198,31,236,31,236,30,183,31,241,31,241,30,241,29,241,28,33,31,33,30,33,29,33,28,49,31,48,31,48,30,48,29,99,31,15,31,15,30,163,31,163,30,202,31,168,31,148,31,148,30,148,29,6,31,125,31,44,31,44,30,57,31,206,31,102,31,248,31,65,31,205,31,198,31,137,31,120,31,193,31,58,31,22,31,2,31,29,31,210,31,36,31,35,31,207,31,2,31,205,31,225,31,221,31,137,31,137,30,149,31,80,31,80,30,249,31,68,31,35,31,33,31,86,31,85,31,103,31,62,31,62,30,138,31,138,30,29,31,119,31,77,31,124,31,50,31,164,31,122,31,213,31,213,30,215,31,215,30,215,29,36,31,241,31,162,31,162,30,253,31,253,30,113,31,220,31,203,31,103,31,153,31,3,31,211,31,120,31,120,30,120,29,120,28,120,27,198,31,122,31,66,31,18,31,207,31,129,31,235,31,56,31,42,31,185,31,214,31,242,31,30,31,66,31,52,31,18,31,164,31,164,30,82,31,82,30,96,31,96,30,96,29,62,31,159,31,156,31,125,31,194,31,149,31,54,31,54,30,97,31,97,30,160,31,160,30,160,29,254,31,254,30,43,31,105,31,92,31,92,30,20,31,20,30,235,31,110,31,27,31,164,31,52,31,47,31,89,31,45,31,72,31,166,31,160,31,192,31,214,31,231,31,85,31,6,31,186,31,33,31,33,30,161,31,125,31,85,31,51,31,51,30,160,31,147,31,134,31,55,31,55,30,36,31,94,31,61,31,135,31,56,31,56,30,66,31,202,31,66,31,99,31,99,30,41,31,120,31,120,30,32,31,1,31,72,31,72,30,209,31,97,31,52,31,203,31,177,31,15,31,173,31,236,31,158,31,82,31,241,31,96,31,69,31,20,31,20,30,158,31,224,31,226,31,11,31,53,31,220,31,220,30,181,31,207,31,8,31,230,31,171,31,204,31,145,31,145,30,107,31,156,31,150,31,171,31,53,31,5,31,117,31,157,31,109,31,109,30,183,31,146,31,65,31,96,31,236,31,236,30,251,31,214,31,214,30,64,31,64,30,97,31,9,31,196,31,197,31,197,30,197,29,197,28,107,31,175,31,100,31,100,30,100,29,25,31,25,30,89,31,180,31,180,30,180,29,183,31,183,30,38,31,200,31,75,31,181,31,45,31,148,31,86,31,22,31,177,31,213,31,42,31,42,30,177,31,205,31,250,31,181,31,180,31,44,31,44,30,222,31,138,31,138,30,138,29,80,31,80,30,53,31,53,30,2,31,72,31,75,31,97,31,7,31,126,31,40,31,132,31,85,31,40,31,55,31,232,31,232,30,221,31,6,31,30,31,235,31,235,30,235,29,123,31,136,31,99,31,99,30,99,29,182,31,86,31,158,31,167,31,76,31,216,31,211,31,117,31,154,31,154,30,71,31,252,31,5,31,161,31,79,31,105,31,51,31,51,30,42,31,78,31,34,31,34,30,231,31,44,31,30,31,99,31,211,31,208,31,208,30,143,31,74,31,218,31,111,31,103,31,211,31,41,31,255,31,255,30);

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
