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

constant SCENARIO_LENGTH : integer := 583;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,72,0,150,0,31,0,62,0,28,0,0,0,171,0,0,0,0,0,228,0,223,0,222,0,102,0,255,0,169,0,246,0,176,0,149,0,43,0,67,0,128,0,150,0,98,0,120,0,85,0,197,0,66,0,158,0,241,0,0,0,0,0,0,0,155,0,162,0,201,0,98,0,147,0,0,0,220,0,0,0,96,0,197,0,82,0,124,0,182,0,156,0,82,0,0,0,93,0,0,0,0,0,67,0,9,0,225,0,101,0,166,0,111,0,161,0,150,0,34,0,93,0,193,0,225,0,248,0,77,0,138,0,0,0,0,0,102,0,75,0,245,0,237,0,98,0,158,0,145,0,107,0,0,0,0,0,162,0,0,0,120,0,217,0,25,0,65,0,0,0,66,0,241,0,96,0,0,0,0,0,96,0,12,0,177,0,213,0,218,0,35,0,11,0,255,0,196,0,79,0,0,0,69,0,0,0,7,0,190,0,182,0,126,0,44,0,0,0,0,0,0,0,41,0,118,0,212,0,189,0,165,0,24,0,224,0,211,0,99,0,78,0,29,0,227,0,195,0,0,0,184,0,0,0,69,0,173,0,0,0,44,0,187,0,211,0,239,0,20,0,2,0,114,0,83,0,230,0,55,0,89,0,48,0,115,0,0,0,194,0,124,0,19,0,136,0,78,0,61,0,248,0,189,0,227,0,22,0,176,0,166,0,217,0,133,0,147,0,0,0,200,0,0,0,0,0,144,0,0,0,0,0,100,0,0,0,214,0,208,0,86,0,209,0,114,0,0,0,138,0,240,0,38,0,43,0,0,0,192,0,172,0,68,0,204,0,106,0,0,0,180,0,247,0,202,0,218,0,27,0,48,0,206,0,65,0,94,0,0,0,0,0,0,0,39,0,119,0,108,0,0,0,0,0,72,0,237,0,221,0,43,0,66,0,189,0,0,0,0,0,12,0,229,0,162,0,115,0,64,0,98,0,88,0,150,0,70,0,168,0,53,0,203,0,202,0,0,0,39,0,69,0,253,0,34,0,81,0,253,0,4,0,168,0,41,0,0,0,186,0,164,0,58,0,232,0,0,0,6,0,92,0,112,0,0,0,214,0,184,0,139,0,252,0,140,0,206,0,128,0,131,0,206,0,65,0,204,0,115,0,173,0,76,0,69,0,59,0,39,0,139,0,115,0,173,0,38,0,222,0,30,0,0,0,0,0,0,0,71,0,75,0,46,0,96,0,204,0,40,0,0,0,34,0,0,0,105,0,0,0,163,0,0,0,159,0,79,0,149,0,185,0,63,0,229,0,0,0,115,0,53,0,152,0,35,0,0,0,222,0,199,0,17,0,192,0,42,0,86,0,118,0,0,0,59,0,183,0,211,0,0,0,0,0,247,0,33,0,147,0,58,0,178,0,195,0,177,0,212,0,98,0,161,0,176,0,142,0,47,0,37,0,76,0,97,0,0,0,255,0,164,0,0,0,17,0,129,0,0,0,255,0,195,0,0,0,187,0,0,0,98,0,0,0,50,0,138,0,71,0,236,0,29,0,238,0,176,0,75,0,201,0,76,0,217,0,0,0,77,0,74,0,112,0,173,0,0,0,0,0,0,0,128,0,58,0,158,0,225,0,22,0,73,0,45,0,0,0,123,0,72,0,113,0,154,0,134,0,31,0,65,0,0,0,30,0,90,0,100,0,108,0,221,0,231,0,33,0,184,0,108,0,195,0,175,0,151,0,185,0,69,0,32,0,0,0,222,0,107,0,53,0,31,0,241,0,0,0,55,0,245,0,171,0,151,0,0,0,252,0,0,0,0,0,0,0,86,0,69,0,182,0,185,0,118,0,169,0,4,0,17,0,29,0,249,0,41,0,29,0,0,0,0,0,161,0,90,0,212,0,0,0,222,0,0,0,146,0,0,0,152,0,139,0,125,0,236,0,211,0,219,0,193,0,114,0,38,0,223,0,186,0,174,0,56,0,42,0,42,0,0,0,82,0,0,0,75,0,72,0,145,0,245,0,165,0,126,0,82,0,251,0,0,0,82,0,41,0,41,0,87,0,245,0,177,0,0,0,255,0,0,0,194,0,87,0,113,0,0,0,161,0,69,0,0,0,97,0,138,0,108,0,64,0,203,0,249,0,205,0,15,0,0,0,43,0,122,0,0,0,226,0,121,0,0,0,38,0,158,0,201,0,0,0,0,0,93,0,231,0,0,0,35,0,0,0,91,0,0,0,98,0,0,0,19,0,126,0,8,0,67,0,240,0,0,0,54,0,0,0,233,0,110,0,148,0,37,0,212,0,125,0,171,0,253,0,113,0,187,0,92,0,241,0,0,0,232,0,195,0,84,0,110,0,94,0,100,0,0,0,37,0,51,0,54,0,166,0,202,0,69,0,24,0,59,0,146,0,5,0,174,0,152,0,0,0,224,0,33,0,97,0,169,0,18,0,203,0,0,0,0,0,62,0,5,0,23,0,8,0,60,0,43,0,124,0,224,0,20,0,199,0,164,0,0,0,20,0,31,0,0,0,220,0,254,0,0,0,0,0,178,0,20,0,127,0,159,0,18,0,87,0,18,0,94,0,9,0,0,0,202,0,0,0,16,0,0,0,85,0,226,0,69,0);
signal scenario_full  : scenario_type := (0,0,72,31,150,31,31,31,62,31,28,31,28,30,171,31,171,30,171,29,228,31,223,31,222,31,102,31,255,31,169,31,246,31,176,31,149,31,43,31,67,31,128,31,150,31,98,31,120,31,85,31,197,31,66,31,158,31,241,31,241,30,241,29,241,28,155,31,162,31,201,31,98,31,147,31,147,30,220,31,220,30,96,31,197,31,82,31,124,31,182,31,156,31,82,31,82,30,93,31,93,30,93,29,67,31,9,31,225,31,101,31,166,31,111,31,161,31,150,31,34,31,93,31,193,31,225,31,248,31,77,31,138,31,138,30,138,29,102,31,75,31,245,31,237,31,98,31,158,31,145,31,107,31,107,30,107,29,162,31,162,30,120,31,217,31,25,31,65,31,65,30,66,31,241,31,96,31,96,30,96,29,96,31,12,31,177,31,213,31,218,31,35,31,11,31,255,31,196,31,79,31,79,30,69,31,69,30,7,31,190,31,182,31,126,31,44,31,44,30,44,29,44,28,41,31,118,31,212,31,189,31,165,31,24,31,224,31,211,31,99,31,78,31,29,31,227,31,195,31,195,30,184,31,184,30,69,31,173,31,173,30,44,31,187,31,211,31,239,31,20,31,2,31,114,31,83,31,230,31,55,31,89,31,48,31,115,31,115,30,194,31,124,31,19,31,136,31,78,31,61,31,248,31,189,31,227,31,22,31,176,31,166,31,217,31,133,31,147,31,147,30,200,31,200,30,200,29,144,31,144,30,144,29,100,31,100,30,214,31,208,31,86,31,209,31,114,31,114,30,138,31,240,31,38,31,43,31,43,30,192,31,172,31,68,31,204,31,106,31,106,30,180,31,247,31,202,31,218,31,27,31,48,31,206,31,65,31,94,31,94,30,94,29,94,28,39,31,119,31,108,31,108,30,108,29,72,31,237,31,221,31,43,31,66,31,189,31,189,30,189,29,12,31,229,31,162,31,115,31,64,31,98,31,88,31,150,31,70,31,168,31,53,31,203,31,202,31,202,30,39,31,69,31,253,31,34,31,81,31,253,31,4,31,168,31,41,31,41,30,186,31,164,31,58,31,232,31,232,30,6,31,92,31,112,31,112,30,214,31,184,31,139,31,252,31,140,31,206,31,128,31,131,31,206,31,65,31,204,31,115,31,173,31,76,31,69,31,59,31,39,31,139,31,115,31,173,31,38,31,222,31,30,31,30,30,30,29,30,28,71,31,75,31,46,31,96,31,204,31,40,31,40,30,34,31,34,30,105,31,105,30,163,31,163,30,159,31,79,31,149,31,185,31,63,31,229,31,229,30,115,31,53,31,152,31,35,31,35,30,222,31,199,31,17,31,192,31,42,31,86,31,118,31,118,30,59,31,183,31,211,31,211,30,211,29,247,31,33,31,147,31,58,31,178,31,195,31,177,31,212,31,98,31,161,31,176,31,142,31,47,31,37,31,76,31,97,31,97,30,255,31,164,31,164,30,17,31,129,31,129,30,255,31,195,31,195,30,187,31,187,30,98,31,98,30,50,31,138,31,71,31,236,31,29,31,238,31,176,31,75,31,201,31,76,31,217,31,217,30,77,31,74,31,112,31,173,31,173,30,173,29,173,28,128,31,58,31,158,31,225,31,22,31,73,31,45,31,45,30,123,31,72,31,113,31,154,31,134,31,31,31,65,31,65,30,30,31,90,31,100,31,108,31,221,31,231,31,33,31,184,31,108,31,195,31,175,31,151,31,185,31,69,31,32,31,32,30,222,31,107,31,53,31,31,31,241,31,241,30,55,31,245,31,171,31,151,31,151,30,252,31,252,30,252,29,252,28,86,31,69,31,182,31,185,31,118,31,169,31,4,31,17,31,29,31,249,31,41,31,29,31,29,30,29,29,161,31,90,31,212,31,212,30,222,31,222,30,146,31,146,30,152,31,139,31,125,31,236,31,211,31,219,31,193,31,114,31,38,31,223,31,186,31,174,31,56,31,42,31,42,31,42,30,82,31,82,30,75,31,72,31,145,31,245,31,165,31,126,31,82,31,251,31,251,30,82,31,41,31,41,31,87,31,245,31,177,31,177,30,255,31,255,30,194,31,87,31,113,31,113,30,161,31,69,31,69,30,97,31,138,31,108,31,64,31,203,31,249,31,205,31,15,31,15,30,43,31,122,31,122,30,226,31,121,31,121,30,38,31,158,31,201,31,201,30,201,29,93,31,231,31,231,30,35,31,35,30,91,31,91,30,98,31,98,30,19,31,126,31,8,31,67,31,240,31,240,30,54,31,54,30,233,31,110,31,148,31,37,31,212,31,125,31,171,31,253,31,113,31,187,31,92,31,241,31,241,30,232,31,195,31,84,31,110,31,94,31,100,31,100,30,37,31,51,31,54,31,166,31,202,31,69,31,24,31,59,31,146,31,5,31,174,31,152,31,152,30,224,31,33,31,97,31,169,31,18,31,203,31,203,30,203,29,62,31,5,31,23,31,8,31,60,31,43,31,124,31,224,31,20,31,199,31,164,31,164,30,20,31,31,31,31,30,220,31,254,31,254,30,254,29,178,31,20,31,127,31,159,31,18,31,87,31,18,31,94,31,9,31,9,30,202,31,202,30,16,31,16,30,85,31,226,31,69,31);

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
